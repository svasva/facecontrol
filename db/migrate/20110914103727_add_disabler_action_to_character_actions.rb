class AddDisablerActionToCharacterActions < ActiveRecord::Migration
  def change
    add_column :character_actions, :disabler_action_id, :integer
  end
end
