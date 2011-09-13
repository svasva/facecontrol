class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.string :name
      t.string :description
      t.references :actions
      t.integer :energy
      t.integer :drive
      t.integer :glory
      t.integer :real_glory
      t.integer :glamour
      t.integer :money

      t.timestamps
    end
    add_index :conditions, :actions_id
  end
end
