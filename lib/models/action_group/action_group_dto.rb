class ActionGroupDTO
	attr_accessor :id
	attr_accessor :flag
	attr_accessor :name
	attr_accessor :description
	attr_accessor :minutes_to_start
	attr_accessor :minutes_to_end
	attr_accessor :count
	attr_accessor :image
	attr_accessor :prise_name
	attr_accessor :price

	def initialize(ag, char = nil)
		cag = char.character_action_groups.where(:action_group_id => ag.id).first if char
		@id = ag.id
		@flag = (char and cag) ? true : false
		@name = ag.name
		@prise_name = ag.prise_name
		@description = ag.description
		@minutes_to_start = (ag.start_time.utc.to_i - Time.now.utc.to_i)/60
		@minutes_to_end = (ag.end_time.utc.to_i - Time.now.utc.to_i)/60
		@count = (char and cag) ? cag.action_group_rating : 0
		@image = ag.image_url
		@price = ag.price
	end
end

class ActionGroup::ActionGroupDTO < ActionGroupDTO
end
