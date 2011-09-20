class AddDeltaWearToActions < ActiveRecord::Migration
  def change
    add_column :actions, :delta_wear, :integer, :default => 0
  end
end
