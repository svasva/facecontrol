class RenameAssociations < ActiveRecord::Migration
  def up
  	rename_column :conditions, :action_id, :game_action_id
  	rename_column :character_actions, :action_id, :game_action_id
  end

  def down
  	rename_column :conditions, :game_action_id, :action_id
  	rename_column :character_actions, :game_action_id, :action_id
  end
end
