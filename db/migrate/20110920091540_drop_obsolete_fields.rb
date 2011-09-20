class DropObsoleteFields < ActiveRecord::Migration
	def up
		remove_column :items, :price
		remove_column :characters, :glamour
	end

	def down
		add_column :items, :price, :integer
		add_column :characters, :glamour, :integer
	end
end
