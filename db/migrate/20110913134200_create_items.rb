class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, :default => ''
      t.text :description, :default => ''
      t.integer :glamour, :default => 0
      t.string :picture_url, :default => ''
      t.integer :price, :default => 0

      t.timestamps
    end
  end
end
