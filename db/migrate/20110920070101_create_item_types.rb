class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.string :name
      t.boolean :wearable, :default => true
      t.boolean :giftable, :default => false
      t.boolean :unique, :default => true
      t.integer :wear_limit, :default => 0
      t.integer :own_limit, :default => 1
      t.boolean :exclusive, :default => false

      t.timestamps
    end
  end
end
