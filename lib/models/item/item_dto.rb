class ItemDTO
	attr_accessor :id
	attr_accessor :name
	attr_accessor :description
	attr_accessor :image
	attr_accessor :ttl

	@id, @source, @description, @image, @ttl = nil;

	def initialize(item)
		@id = item.id
		@name = item.name
		@description = item.description
		@image = item.picture_url
		@ttl = item.ttl
	end
end

class Item::ItemDTO < ItemDTO
end
