class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name
      t.text :description
      t.references :conditions
      t.integer :delay
      t.integer :parent_id
      t.boolean :has_children
      t.timestamp :start_time

      t.timestamps
    end
    add_index :actions, :conditions_id
  end
end
