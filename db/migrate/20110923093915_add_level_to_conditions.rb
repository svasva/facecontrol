class AddLevelToConditions < ActiveRecord::Migration
  def change
    add_column :conditions, :level, :integer
  end
end
