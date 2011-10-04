class CharacterItemDTO < ItemDTO
	attr_accessor :char_item
	attr_accessor :current_glamour
	attr_accessor :equipped
	attr_accessor :ttl

	@glamour, @equipped, @char_item = nil

	def initialize(char_item)
		super(char_item.item)
		@char_item = char_item.id
		@current_glamour = char_item.glamour
		@equipped = char_item.equipped
		@ttl = char_item.remaining_ttl
	end
end

class CharacterItem::CharacterItemDTO < CharacterItemDTO
end
