class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.string :name
      t.boolean :wearable
      t.boolean :giftable
      t.boolean :unique
      t.integer :wear_limit
      t.integer :own_limit
      t.boolean :exclusive

      t.timestamps
    end
  end
end
