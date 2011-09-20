class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name, :default => ''
      t.text :description, :default => ''
      t.integer :delay, :default => 0
      t.integer :parent_id, :default => 0

      t.timestamps
    end
  end
end
