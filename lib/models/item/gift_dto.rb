class GiftDTO < ItemDTO
	attr_accessor :source

	@source = nil;

	def initialize(char_item)
		super(char_item.item)
		@source = char_item.source_character.dto
	end
end
