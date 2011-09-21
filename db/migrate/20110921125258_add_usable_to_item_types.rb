class AddUsableToItemTypes < ActiveRecord::Migration
  def change
    add_column :item_types, :usable, :boolean
    add_index :item_types, :usable
  end
end
