class AddRepeatToActions < ActiveRecord::Migration
  def change
    add_column :actions, :repeat, :boolean
  end
end
