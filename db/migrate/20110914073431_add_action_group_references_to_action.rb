class AddActionGroupReferencesToAction < ActiveRecord::Migration
  def change
    add_column :actions, :action_group_id, :integer
    add_index :actions, :action_group_id
  end
end
