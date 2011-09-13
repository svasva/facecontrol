class Character < ActiveRecord::Base
	has_many :character_actions

  def pass_condition?(condition)
  	condition.attributes.each {|k,v|
  		puts "#{k}: #{v}"
  		next if k.match /_at$|_?id$|description|name/ or v == nil
  		return false if v > self.attributes[k]
  	}
  	return true
  end
end
