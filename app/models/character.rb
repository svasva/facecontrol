class Character < ActiveRecord::Base
	has_many :character_actions, :dependent => :destroy
	has_many :actions, :through => :character_actions
	has_many :character_action_groups, :dependent => :destroy
	has_many :action_groups, :through => :character_action_groups
	has_many :character_items, :dependent => :destroy
	has_many :items, :through => :character_items
	belongs_to :place
	has_many :equipped_character_items,
		:class_name => 'CharacterItem',
		:conditions => { :equipped => true }

	has_many :equipped_items,
		:through => :equipped_character_items,
		:class_name => 'Item',
		:source => :item

	has_many :rumors,
		:class_name => 'Message',
		:conditions => { :need_answer => false },
		:foreign_key => 'target_id'

	has_many :questions,
		:class_name => 'Message',
		:conditions => { :need_answer => true },
		:foreign_key => 'target_id'

	has_many :relations, :class_name => 'CharacterRelation'

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

	def dto
		CharacterDTO.new self
	end

	def gifts
		CharacterItem.gifts.where(:character_id => self.id)
	end

	def gift_drinks
		CharacterItem.gift_drinks.where(:character_id => self.id)
	end

	def clothes
		CharacterItem.clothes.where(:character_id => self.id)
	end

	def level
		g = self.glory
		GloryLevel.where{(glory.lteq g)}.order('glory asc').last.level
	end

	def glamour
		glam = 0
		self.equipped_character_items.each { |item| glam += item.glamour }
		return glam
	end

	def buy_item(item)
		self.do_action item.buy_action
	end

	def use_item(item)
		self.do_action item.use_action
	end

	def make_a_gift(item, target_character)
		if item.item_type.giftable
			return item if self.do_action item.gift_action, target_character 
		end
	end

	def post_rumor(content, target_char)
		self.do_action Action.post_rumor.last, target_char, Message.create(
			:source => self,
			:target => target_char,
			:need_answer => false,
			:content => content
		)
	end

	def post_question(content, target_char)
		self.do_action Action.post_question.last, target_char, Message.create(
			:source => self,
			:target => target_char,
			:need_answer => true,
			:content => content
		)
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
		return place if self.place and self.do_action place.leave_action
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
	  		if k == 'relation_index'
	  			#TODO check relation
	  			next
	  		end
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
	 	return false unless self.pass_conditions? action
	 	CharacterAction.create(
	 		:character => self,
	 		:action => action,
	 		:target_character => target_char,
	 		:message => message
	 	)
	 end

	def modify(action)
	 	new_attributes = {}
	 	max_energy = GloryLevel.find(:first, :conditions => {:level => self.level}).max_energy
	 	action.attributes.each {|attrib,value|
			next unless attrib.match /delta_/ and value != nil and value != 0
			if attrib == 'delta_relation_index'
				next
				#TODO modify relation
			end
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
