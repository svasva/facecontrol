class CreateCharacterActionGroups < ActiveRecord::Migration
  def change
    create_table :character_action_groups do |t|
      t.references :action_group
      t.references :character
      t.integer :action_group_rating, :default => 0

      t.timestamps
    end
    add_index :character_action_groups, [:action_group_id, :character_id], :name => 'cag_index'
  end
end
