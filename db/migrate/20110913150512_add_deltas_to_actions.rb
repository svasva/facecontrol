class AddDeltasToActions < ActiveRecord::Migration
  def change
    add_column :actions, :delta_energy, :integer
    add_column :actions, :delta_glory, :integer
    add_column :actions, :delta_drive, :integer
    add_column :actions, :delta_glamour, :integer
    add_column :actions, :delta_real_glory, :integer
    add_column :actions, :delta_money, :integer
  end
end
