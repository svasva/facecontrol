class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.integer :glamour
      t.references :conditions
      t.string :picture_url
      t.integer :price

      t.timestamps
    end
    add_index :items, :conditions_id
  end
end
