class ItemDTO
	attr_accessor :id
	attr_accessor :name
	attr_accessor :description
	attr_accessor :image
	attr_accessor :ttl
	attr_accessor :properties
	attr_accessor :glamour
	attr_accessor :type

	@id, @source, @description, @image, @ttl, @properties, @type = nil;

	def initialize(item)
		@id = item.id
		@name = item.name
		@description = item.description
		@image = item.picture_url
		@ttl = item.ttl
		@glamour = item.glamour
		@properties = item.buy_action.dto
		@type = item.item_type.description
	end
end

class Item::ItemDTO < ItemDTO
end
