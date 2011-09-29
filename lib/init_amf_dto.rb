class InitAmfDTO
	attr_accessor :friends
	attr_accessor :tops
	attr_accessor :contacts
	attr_accessor :places
	attr_accessor :usable_items
	attr_accessor :wearable_items
	attr_accessor :giftable_items
	attr_accessor :my_gifts
	attr_accessor :my_rumors
	attr_accessor :my_interviews
	attr_accessor :my_items
	attr_accessor :club
	attr_accessor :new_contacts
	attr_accessor :free_bar
	attr_accessor :new_gifts
	attr_accessor :relations
	attr_accessor :contest
	attr_accessor :top_rumor
	attr_accessor :top_avatar
	attr_accessor :exchange_rates

	def initialize(char, friends)
		@contest = ActionGroup.last.dto(char) if ActionGroup.count > 0
		@places = Place.all.map(&:dto)
		@usable_items = Item.usable.map(&:dto)
		@giftable_items = Item.giftable.map(&:dto)
		@wearable_items = Item.wearable.order('glamour ASC').where(:sex => char.sex).map(&:dto)
		@my_gifts = char.items.gifts.map(&:gift_dto)
		@my_rumors = char.messages.rumors.map(&:dto)
		@my_interviews = char.messages.questions.map(&:dto)
		@club = char.place.club_dto(char) unless char.place.nil?
		@new_gifts = char.items.gifts.where('character_items.created_at > ?', char.updated_at).map(&:gift_cdto)
		@my_items = char.items.clothes.map(&:dto)
		@free_bar = char.items.gift_drinks.map(&:dto)

		@friends = Character.where(:social_id => friends).map(&:dto)
		@tops = Character.top10.map(&:dto)

		@contacts = char.contacts.map(&:dto)
		@new_contacts = char.contact_requests.map(&:dto)
		@relations = RelationsDTO.new(RelationLevel.order('relation_index DESC'))
		@top_rumor = Message.top10.first.dto if Message.top10.count > 0
		@top_avatar = Character.order('photo_rating DESC').first.dto
		@exchange_rates = ExchangeRate.order('game_value ASC').map {|er|
			[er.id, er.social_price, er.game_value, er.game_string]
		}
	end
end
