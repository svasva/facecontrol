# encoding: utf-8

class Character < ActiveRecord::Base
	has_many :character_actions, :dependent => :destroy
	has_many :game_actions, :through => :character_actions
	has_many :character_action_groups, :dependent => :destroy
	has_many :action_groups, :through => :character_action_groups
	has_many :items, :class_name => 'CharacterItem', :dependent => :destroy
	has_many :messages, :foreign_key => 'target_id', :dependent => :destroy
	has_many :source_items, :class_name => 'CharacterItem', :foreign_key => 'source_character_id', :dependent => :destroy
	has_many :source_messages, :class_name => 'Message', :foreign_key => 'source_id', :dependent => :destroy
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
	scope :ag_leaders, lambda {|ag_id|
		joins(:character_action_groups)
		.where(:character_action_groups => {:action_group_id => ag_id})
		.order('character_action_groups.action_group_rating DESC')
		.limit(10)
	}

	def login_hook
		# placeholder
	end

	def acquire_default_rumors
		begin
			src = Character.find_by_social_id(137934885).id
	    Message.create(
	      :source_id => src,
	      :target_id => self.id,
	      :need_answer => false,
	      :rating => 100,
	      :content => "#{self.name} начал#{'a' unless self.male} играть в Face Control"
	    )
	    Message.create(
	      :source_id => src,
	      :target_id => self.id,
	      :need_answer => false,
	      :rating => 100,
	      :content => "#{self.name} любит ходить по клубам"
	    )
	    Message.create(
	      :source_id => src,
	      :target_id => self.id,
	      :need_answer => false,
	      :rating => 100,
	      :content => "#{self.name} нравится играть в игры"
	    )
	  rescue => e
	  	logger.error e.inspect
	  end
	end

	def social_friends
		begin
			friends = FCconfig.vk_session.friends.get(:uid => self.social_id).map {|f| f['uid']}
			Character.where(:social_id => friends)
		rescue => e
			logger.error "#{Time.now.to_s(:short)} ACHTUNG! Character#social_friends failed: #{e.inspect}"
		end
	end

	def social_friends_count
		self.social_friends.count
	end

	def ignore_char(char_id)
		rel = (self.relations.where(:target_id => char_id) or self.relations.create(:target_id => char_id))
		rel.update_attributes :ignore => true
	end

	def ignore_msg(msg_id)
		return false unless (msg = Message.find(msg_id)) and msg.target_id == self.id
		msg.update_attributes :ignore => true
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
		return 0 unless self.glory >= 0
		g = self.glory
		GloryLevel.where{(glory.lteq g)}.order('glory asc').last.level
	end

	def max_energy
		return 0 unless self.glory >= 0
		g = self.glory
		GloryLevel.where{(glory.lteq g)}.order('glory asc').last.max_energy
	end

	def glamour
		glam = 0
		self.items.clothes.equipped.each { |item| glam += item.glamour }
		return glam
	end

	def buy_item(item, for_gold = false)
		self.do_action (for_gold ? item.buy_for_gold_action : item.buy_action)
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

	def make_a_gift(item, target_character, for_gold = false)
		if item.item_type.giftable
			return item if self.do_action (for_gold ? item.gift_for_gold_action : item.gift_action), target_character 
		else
			return false
		end
	end

	def post_message(content, target_char_id, need_answer, anonymous = false)
		msg = Message.create(
			:source => self,
			:target_id => target_char_id,
			:need_answer => need_answer,
			:content => content,
			:rating => 100,
			:anonymous => anonymous
		)
		if need_answer
			self.do_action GameAction.post_question.last, Character.find(target_char_id), msg
		else
			self.do_action GameAction.post_rumor.last, Character.find(target_char_id), msg
		end
		return msg
	end

	def vote_for_message(message, plus)
		msg = Message.find(message)
		rating = (msg.rating ? msg.rating : 0) + (plus ? 1 : -1)
		msg.update_attributes(:rating => rating)
	end

	def vote_for_char(char_id, plus)
		char = Character.find(char_id)
		rating = char.photo_rating + (plus ? 1 : -1)
		char.update_attributes(:photo_rating => rating)
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
		self.do_action GameAction.post_reply.last, msg.source, rpl
		return msg
	end

	def buy_clicks
		self.do_action GameAction.buy_clicks.last
	end

	def clicks_remaining
		count_from = Time.now.utc - 1.day
		#count_from = self.bought_clicks_at if self.bought_clicks_at and self.bought_clicks_at > count_from
		(100 + self.paid_clicks) - self.character_actions.votes.where{created_at.gteq count_from}.count
	end

	def can_put_on?(char_item)
		return false unless char_item.character_id == self.id
		return false unless char_item.wearable?
		return false if char_item.wear_limit and char_item.find_same_type_eq.count >= char_item.wear_limit
		return true
	end

	def put_on(char_item)
		return false if char_item.equipped
		# monkeypatch to take off all equipped clothes
		self.items.equipped.each {|i| self.take_off i}
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
				logger.info "\tcondition '#{k}': #{self.send(k.to_sym)} #{condition.operator} #{v}"
				case condition.operator
					when '<'
						return false unless self.send(k.to_sym) < v
					when '<='
						return false unless self.send(k.to_sym) <= v
					when '>='
						return false unless self.send(k.to_sym) >= v
					when '>'
						return false unless self.send(k.to_sym) > v
					when '!='
						return false unless self.send(k.to_sym) != v
					when '='
						return false unless self.send(k.to_sym) == v
				end
				logger.info "\t^ OK ^"
			}
		}
		return true
	 end

	 # creates CharacterAction for corresponding GameAction
	 # if character passes GameAction`s conditions
	 # otherwise returns false
	 def do_action(action, target_char = nil, message = nil)
		unless self.pass_conditions? action
			self.update_attributes(:place_id => nil) if action.default_type == 'stay'
			return false
		end
		CharacterAction.create(
			:character => self,
			:game_action => action,
			:target_character => target_char,
			:message => message
		)
	 end

	def modify(action, target_id)
		puts "modify #{self.name}"
		new_attributes = {}
		max_energy = GloryLevel.find(:first, :conditions => {:level => self.level}).max_energy
		action.attributes.each {|attrib,value|
			next if value.nil? or value == 0
			# special attributes
			case attrib
			when 'contest_rating'
				if (cag = self.character_action_groups.last)
					puts "\tmodify contest_rating : #{cag.action_group_rating} + #{value}"
					cag.update_attributes :action_group_rating => (cag.action_group_rating + value)
				end
				next
			when 'delta_relation_index'
				puts "\tmodify relation to #{Character.find(target_id).name}: #{value}"
				rel = (self.relations.where(:target_id => target_id) or self.relations.create(:target_id => target_id))
				rel.update_attributes :index => rel.index+value
				next
			when 'delta_wear'
				self.items.clothes.equipped.each {|item|
					puts "\twear item #{item.item.name} : #{value}"
					CharacterItem.find(item.id).update_attributes(:wear => (item.wear or 0) + value)
				}
				next
			end

			next unless attrib.match /delta_/
			attrib = attrib.match('delta_(.*)')[1]
			new_attributes[attrib] = (self.attributes[attrib] != nil) ? self.attributes[attrib] + value : value
			if attrib == 'energy' and new_attributes[attrib] > max_energy
				new_attributes[attrib] = max_energy
			end
			puts "\tmodify '#{attrib}': #{self.attributes[attrib]} += #{value} = #{new_attributes[attrib]}"
		}
		self.update_attributes(new_attributes)
	end

	def withraw_vk(exchange_rate, app_id, app_secret)
		session = ::VkApi::Session.new app_id, app_secret
		if session.secure.withdrawVotes :timestamp => Time.now.utc.to_i, :uid => self.social_id, :votes => exchange_rate.social_price * 100
			self.do_action exchange_rate.buy_action
			return true
		else
			return false
		end
	end
end
