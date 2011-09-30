class GiftDTO < ItemDTO
	attr_accessor :source
	attr_accessor :remaining_ttl
	attr_accessor :charitem_id

	@source, @remaining_ttl = nil;

	def initialize(char_item)
		super(char_item.item)
		@properties = char_item.item.use_action.dto if char_item.item.item_type.name == 'drink'
		@charitem_id = char_item.id
		@source = char_item.source_character.dto
		@remaining_ttl = char_item.remaining_ttl
	end
end
