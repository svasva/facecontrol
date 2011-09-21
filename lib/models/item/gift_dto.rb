class GiftDTO < ItemDTO
	attr_accessor :source
	attr_accessor :remaining_ttl

	@source, @remaining_ttl = nil;

	def initialize(char_item)
		super(char_item.item)
		@source = char_item.source_character.dto
		@remaining_ttl = char_item.remaining_ttl
	end
end
