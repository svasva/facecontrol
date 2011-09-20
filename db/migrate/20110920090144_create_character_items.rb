class CreateCharacterItems < ActiveRecord::Migration
  def change
    create_table :character_items do |t|
      t.references :character
      t.references :item
      t.boolean :equipped, :default => false
      t.boolean :gift, :default => false
      t.integer :wear, :default => 0

      t.timestamps
    end
    add_index :character_items, :character_id
    add_index :character_items, :item_id
  end
end
