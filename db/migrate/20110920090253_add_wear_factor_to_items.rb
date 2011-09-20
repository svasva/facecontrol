class AddWearFactorToItems < ActiveRecord::Migration
  def change
    add_column :items, :wear_factor, :float, :default => 1.0
  end
end
