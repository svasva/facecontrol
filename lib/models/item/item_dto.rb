class ItemDTO
	attr_accessor :id
	attr_accessor :name
	attr_accessor :description
	attr_accessor :price_gold
	attr_accessor :price_energy
	attr_accessor :image
	attr_accessor :ttl

	@id, @source, @description, @price_gold, @price_energy, @image, @ttl = nil;

	def initialize(item)
		@id = item.id
		@name = item.name
		@description = item.description
		@price_gold = item.buy_for_money_action.delta_money
		@price_energy = item.buy_for_energy_action.delta_energy
		@image = item.picture_url
		@ttl = item.ttl
	end
end

class Item::ItemDTO < ItemDTO
end
