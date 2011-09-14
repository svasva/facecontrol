class AddTargetCharacterToCharacterAction < ActiveRecord::Migration
  def change
    add_column :character_actions, :target_character_id, :integer
  end
end
