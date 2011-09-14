class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, :default => ''
      t.text :description, :default => ''
      t.integer :glamour, :default => 0
      t.references :conditions
      t.string :picture_url, :default => ''
      t.integer :price, :default => 0

      t.timestamps
    end
    add_index :items, :conditions_id
  end
end
