class CreateRelationLevels < ActiveRecord::Migration
  def change
    create_table :relation_levels do |t|
      t.integer :relation_index
      t.boolean :allow_travel
      t.boolean :allow_friendship_request

      t.timestamps
    end
  end
end
