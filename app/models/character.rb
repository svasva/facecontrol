class Character < ActiveRecord::Base
	has_many :character_actions, :dependent => :destroy
	has_many :actions, :through => :character_actions
	has_many :character_action_groups, :dependent => :destroy
	has_many :action_groups, :through => :character_action_groups
	has_many :items, :class_name => 'CharacterItem', :dependent => :destroy
	has_many :messages, :foreign_key => 'target_id', :dependent => :destroy
	has_many :relations, :class_name => 'CharacterRelation', :dependent => :destroy
	belongs_to :place

	has_many :contacts,
		:through => :relations,
		:class_name => 'Character',
		:source => :character,
		:conditions => { :character_relations => {:friendship => true} }

	has_many :contact_requests,
		:through => :relations,
		:class_name => 'Character',
		:source => :target,
		:conditions => { :character_relations => {:friendship => false, :friendship_request => true} }
	
	scope :top10, order('glory DESC').limit(10)

	def login_hook
		# placeholder
	end

	def restore_energy
		return false unless self.updated_at
		bonus_energy = (Time.now.utc.to_i - self.updated_at.to_i)/60
		energy = (self.energy + bonus_energy) > self.max_energy ? self.max_energy : (self.energy + bonus_energy)
		self.update_attributes(:energy => energy)
	end

	def dto(char_id = nil)
		CharacterDTO.new self, char_id
	end

	def level
		g = self.glory
		GloryLevel.where{(glory.lteq g)}.order('glory asc').last.level
	end

	def max_energy
		g = self.glory
		GloryLevel.where{(glory.lteq g)}.order('glory asc').last.max_energy
	end

	def glamour
		glam = 0
		self.items.clothes.equipped.each { |item| glam += item.glamour }
		return glam
	end

	def buy_item(item)
		self.do_action item.buy_action
	end

	def use_item(item)
		self.do_action item.use_action
	end

	def enter_contest(ag_id)
		ag = ActionGroup.find(ag_id)
		return false unless ag

		self.character_action_groups << CharacterActionGroup.create(
			:action_group_id => ag_id,
			:action_group_rating => 0
		) if self.do_action ag.enter_action
		return self
	end

	def make_a_gift(item, target_character)
		if item.item_type.giftable
			return item if self.do_action item.gift_action, target_character 
		end
	end

	def post_message(content, target_char_id, need_answer)
		msg = Message.create(
			:source => self,
			:target_id => target_char_id,
			:need_answer => need_answer,
			:content => content,
			:rating => 100
		)
		if need_answer
			self.do_action Action.post_question.last, Character.find(target_char_id), msg
		else
			self.do_action Action.post_rumor.last, Character.find(target_char_id), msg
		end
		return msg
	end

	def vote_for_message(message, plus)
		msg = Message.find(message)
		rating = (msg.rating ? msg.rating : 0) + (plus ? 1 : -1)
		msg.update_attributes(:rating => rating)
	end

	def post_reply(content, message_id)
		msg = Message.find(message_id)
		rpl = Message.create(
			:source_id => self.id,
			:target_id => msg.source_id,
			:content => content,
			:need_answer => false,
			:reply_to => message_id
		)
		self.do_action Action.post_reply.last, msg.source, rpl
		return msg
	end

	def can_put_on?(char_item)
		return false unless char_item.character_id == self.id
		return false unless char_item.wearable?
		return false if char_item.wear_limit and char_item.find_same_type_eq.count >= char_item.wear_limit
		return true
	end

	def put_on(char_item) #TODO can_put_on? method
		return false if char_item.equipped
		char_item.find_same_type_eq.each { |ci| self.take_off ci } if char_item.unique?
		char_item.update_attributes :equipped => true if self.can_put_on? char_item
		return char_item
	end

	def enter_place(place)
		return place if self.do_action place.enter_action
	end

	def leave_place
		self.do_action place.leave_action if self.place
		return self
	end

	def take_off(char_item)
		logger.info "take off #{char_item.inspect}"
		#self.do_action character_item.item.take_off_action if character_item.character.id == self.id
		CharacterItem.update char_item.id, :equipped => false
		return char_item
	end

	def pass_conditions?(obj)
		logger.info "= #{obj.class}(#{obj.id}) conditions check ="
		obj.conditions.each {|condition|
			condition.attributes.each {|k,v|
				next if k.match /_at$|_?id$|description|name|operator/ or v == nil
				logger.info "\tcondition '#{k}': #{self.attributes[k]} #{condition.operator} #{v}"
				case condition.operator
					when '<'
						return false unless self.attributes[k] < v
					when '<='
						return false unless self.attributes[k] <= v
					when '>='
						return false unless self.attributes[k] >= v
					when '>'
						return false unless self.attributes[k] > v
					when '!='
						return false unless self.attributes[k] != v
					when '='
						return false unless self.attributes[k] == v
				end
			}
		}
		return true
	 end

	 # creates CharacterAction for corresponding Action
	 # if character passes Action`s conditions
	 # otherwise returns false
	 def do_action(action, target_char = nil, message = nil)
		unless self.pass_conditions? action
			self.update_attributes(:place_id => nil) if action.default_type == 'stay'
			return false
		end
		CharacterAction.create(
			:character => self,
			:action => action,
			:target_character => target_char,
			:message => message
		)
	 end

	def modify(action, target_id)
		new_attributes = {}
		max_energy = GloryLevel.find(:first, :conditions => {:level => self.level}).max_energy
		action.attributes.each {|attrib,value|
			next unless value != nil and value != 0
			# special attributes
			case attrib
			when 'contest_rating'
				if (cag = self.character_action_groups.last) and cag
					cag.update_attributes :action_group_rating => (cag.action_group_rating + contest_rating)
				end
				next
			when 'delta_relation_index'
				rel = (self.relations.where(:target_id => target_id) or self.relations.create(:target_id => target_id))
				rel.update_attributes :index => rel.index+value
				logger.info "\tmodify relation to #{Character.find(target_id).name}: #{value}"
				next
			when 'delta_wear'
				self.items.clothes.equipped.each {|item|
					item.update_attributes(:wear => (item.wear or 0) + value)
				}
				next
			end

			next unless attrib.match /delta_/
			attrib = attrib.match('delta_(.*)')[1]
			new_attributes[attrib] = (self.attributes[attrib] != nil) ? self.attributes[attrib] + value : value
			if attrib == 'energy' and new_attributes[attrib] > max_energy
				new_attributes[attrib] = max_energy
			end
			logger.info "\tmodify '#{attrib}': #{self.attributes[attrib]} += #{value} = #{new_attributes[attrib]}"
		}
		self.update_attributes(new_attributes)
	end

end
