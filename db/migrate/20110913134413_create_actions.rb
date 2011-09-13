class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name
      t.text :description
      t.integer :delay
      t.integer :parent_id
      t.boolean :has_children

      t.timestamps
    end
    create_table :actions_conditions, :id => false do |t|
      t.references :action, :condition
    end
    add_index :actions_conditions, [:action_id, :condition_id]
  end
end
