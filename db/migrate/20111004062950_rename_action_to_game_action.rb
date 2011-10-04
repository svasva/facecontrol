class RenameActionToGameAction < ActiveRecord::Migration
  def up
  	rename_table :actions, :game_actions
  end

  def down
  	rename_table :game_actions, :actions
  end
end
