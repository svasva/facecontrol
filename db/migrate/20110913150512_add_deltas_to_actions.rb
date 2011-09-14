class AddDeltasToActions < ActiveRecord::Migration
  def change
    add_column :actions, :delta_energy, :integer, :default => 0
    add_column :actions, :delta_glory, :integer, :default => 0
    add_column :actions, :delta_drive, :integer, :default => 0
    add_column :actions, :delta_glamour, :integer, :default => 0
    add_column :actions, :delta_real_glory, :integer, :default => 0
    add_column :actions, :delta_money, :integer, :default => 0
  end
end
