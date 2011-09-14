class AddRepeatToActions < ActiveRecord::Migration
  def change
    add_column :actions, :repeat, :boolean, :default => false
  end
end
