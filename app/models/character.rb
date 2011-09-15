class Character < ActiveRecord::Base
	has_many :character_actions
	has_many :action_groups, :through => :character_action_groups
	has_many :character_action_groups

	def cloth_id
		1
	end

  def pass_conditions?(obj)
  	logger.info "= #{obj.class}(#{obj.id}) conditions check ="
  	ret = true
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
	  				return false unless self.attributes[k] == v
	  			when '='
	  				return false unless self.attribuunlesstes[k] != v
	  		end
	  	}
	 	}
	 	return true
	 end

	 def modify(action)
	 	action.attributes.each {|k,v|
	 		next unless k.match /delta_/ and v != nil
	  		logger.info "\tmodify '#{k}': #{self.attributes[k]} += #{v}"
	 	}
	 end
end
