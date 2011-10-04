class PlaceDTO
	attr_accessor :id
	attr_accessor :name
	attr_accessor :description
	attr_accessor :visible_properties
	attr_accessor :enabled_properties
	attr_accessor :rating
	attr_accessor :map_x
	attr_accessor :map_y

	@id, @name, @description, @visible_properties, @enabled_properties, @rating, @map_x, @map_y = nil

	def initialize(place, char = nil)
		@id = place.id
		@name = place.name
		@description = place.description
		@visible_properties = []
		@enabled_properties = []
		place.enter_action.conditions.each {|c|
			if c.name == 'visible_condition'
				@visible_properties << c.dto
			else
				@enabled_properties << c.dto
			end
		}
		@rating = char.game_actions.by_place(place.id).sum(:delta_glory) unless char.nil?
		@map_x = place.map_x
		@map_y = place.map_y
	end
end

class Place::PlaceDTO < PlaceDTO
end
