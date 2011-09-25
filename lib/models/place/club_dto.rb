class ClubDTO < PlaceDTO
	attr_accessor :videos
	attr_accessor :visitors
	attr_accessor :bar_factor
	attr_accessor :interval
	attr_accessor :char_modifier

	@videos, @visitors, @bar_factor = nil

	def initialize(place, char = nil)
		super(place, char)
		@videos = place.video_urls.split("\n") unless place.video_urls.nil? or place.video_urls.empty?
		@visitors = CharacterAction.where(:action_id => place.enter_action).where{character_id.not_eq char.id unless char.nil?}.order('id DESC').limit(50).map {|ca| ca.character.dto(char.id)}
		@bar_factor = 1
		@interval = place.stay_action.delay
		@char_modifier = place.stay_action.dto
	end
end

class Place::ClubDTO < ClubDTO
end
