class AddItemTypeToItems < ActiveRecord::Migration
  def change
    add_column :items, :item_type_id, :references
    add_index :items, :item_type_id
  end
end
