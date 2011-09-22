class ClubDTO < PlaceDTO
	attr_accessor :videos
	attr_accessor :visitors
	attr_accessor :bar_factor

	@videos, @visitors, @bar_factor = nil

	def initialize(place, char = nil)
		super(place, char)
		@videos = place.video_urls.split("\n")
		@visitors = CharacterAction.where(:action_id => place.enter_action).order('id DESC').limit(50).map {|ca| ca.character.dto}
		@bar_factor = 1
	end
end

class Place::ClubDTO < ClubDTO
end
