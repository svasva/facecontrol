class AddDisablerActionToActions < ActiveRecord::Migration
  def change
    add_column :actions, :disabler_action_id, :integer
  end
end
