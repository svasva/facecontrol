class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name, :default => ''
      t.text :description, :default => ''
      t.integer :delay, :default => 0
      t.integer :parent_id, :default => 0
      t.boolean :has_children, :default => false

      t.timestamps
    end
    create_table :actions_conditions, :id => false do |t|
      t.references :action, :condition
    end
    add_index :actions_conditions, [:action_id, :condition_id]
  end
end
