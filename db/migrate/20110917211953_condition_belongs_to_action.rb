class ConditionBelongsToAction < ActiveRecord::Migration
  def change
  	drop_table :actions_conditions
  	rename_column :conditions, :actions_id, :action_id
  end
end
