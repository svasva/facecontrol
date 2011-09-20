class AddItemTypeToItems < ActiveRecord::Migration
  def change
    add_column :items, :item_type_id, :integer
    add_index :items, :item_type_id
  end
end
