class Character < ActiveRecord::Base
	has_many :character_actions
	has_many :character_action_groups
	has_many :action_groups, :through => :character_action_groups
	has_many :character_items
	has_many :items, :through => :character_items
	has_many :equipped_character_items,
		:class_name => 'CharacterItem',
		:conditions => {:equipped => true}

	has_many :equipped_items,
		:through => :equipped_character_items,
		:class_name => 'Item',
		:source => :item

	has_many :gift_items,
		:class_name => 'CharacterItem',
		:conditions => {:gift => true}

	def dto
		CharacterDTO.new self
	end

	def glamour
		glam = 0
		self.equipped_character_items.each { |item| glam += item.glamour }
		return glam
	end

	def buy_item_for_money(item)
		self.do_action item.buy_for_money_action
	end

	def buy_item_for_energy(item)
		self.do_action item.buy_for_energy_action
	end

	def make_a_gift_for_money(item, target_character)
		self.do_action item.gift_for_money_action, target_character if item.item_type.giftable
	end

	def make_a_gift_for_energy(item, target_character)
		self.do_action item.gift_for_energy_action, target_character if item.item_type.giftable
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
	end

	def take_off(char_item)
		logger.info "take off #{char_item.inspect}"
		#self.do_action character_item.item.take_off_action if character_item.character.id == self.id
		CharacterItem.update char_item.id, :equipped => false
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
	  				return false unless self.attribuunlesstes[k] == v
	  		end
	  	}
	 	}
	 	return true
	 end

	 # creates CharacterAction for corresponding Action
	 # if character passes Action`s conditions
	 # otherwise returns false
	 def do_action(action, target_char = nil)
	 	return false unless self.pass_conditions? action
	 	CharacterAction.create(
	 		:character => self,
	 		:action => action,
	 		:target_character => target_char
	 	)
	 end

	def modify(action)
	 	new_attributes = {}
	 	action.attributes.each {|attrib,value|
			next unless attrib.match /delta_/ and value != nil and value != 0
			attrib = attrib.match('delta_(.*)')[1]
			new_attributes[attrib] = (self.attributes[attrib] != nil) ? self.attributes[attrib] + value : value
			logger.info "\tmodify '#{attrib}': #{self.attributes[attrib]} += #{value} = #{new_attributes[attrib]}"
		}
		self.update_attributes(new_attributes)
	end

end
