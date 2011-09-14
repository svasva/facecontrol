class CreateActionGroups < ActiveRecord::Migration
  def change
    create_table :action_groups do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
