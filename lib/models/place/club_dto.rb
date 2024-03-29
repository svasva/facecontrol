class ClubDTO < PlaceDTO
	attr_accessor :videos
	attr_accessor :visitors
	attr_accessor :bar_factor
	attr_accessor :interval
	attr_accessor :char_modifier

	@videos, @visitors, @bar_factor = nil

	def initialize(place, char = nil)
		place = Place.find(place) unless place.kind_of? Place
		super(place, char)
		@videos = place.video_urls.split("\n") unless place.video_urls.nil?
		@visitors = place.last_visitors_dto(char.id)
		@bar_factor = 1
		@interval = place.stay_action.delay
		@char_modifier = place.stay_action.dto
	end
end

class Place::ClubDTO < ClubDTO
end
