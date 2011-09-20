class Character < ActiveRecord::Base
	has_many :character_actions
	has_many :character_action_groups
	has_many :action_groups, :through => :character_action_groups
	attr_accessor :cloth_id
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

	def cloth_id
		1
	def dto
		CharacterDTO.new self
	end
	end

	def amf
		self.to_amf(:except => [:updated_at, :created_at])
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
			next unless attrib.match /delta_/ and value != nil
			attrib = attrib.match('delta_(.*)')[1]
			new_attributes[attrib] = (self.attributes[attrib] != nil) ? self.attributes[attrib] + value : value
			logger.info "\tmodify '#{attrib}': #{self.attributes[attrib]} += #{value} = #{new_attributes[attrib]}"
		}
		self.update_attributes(new_attributes)
	end

end
