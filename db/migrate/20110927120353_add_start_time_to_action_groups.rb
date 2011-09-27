class AddStartTimeToActionGroups < ActiveRecord::Migration
  def change
    add_column :action_groups, :start_time, :timestamp
  end
end
