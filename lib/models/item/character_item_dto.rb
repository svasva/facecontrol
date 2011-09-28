class CharacterItemDTO < ItemDTO
	attr_accessor :char_item
	attr_accessor :current_glamour
	attr_accessor :equipped

	@glamour, @equipped, @char_item = nil

	def initialize(char_item)
		super(char_item.item)
		@char_item = char_item.id
		@current_glamour = char_item.glamour
		@equipped = char_item.equipped
	end
end

class CharacterItem::CharacterItemDTO < CharacterItemDTO
end
