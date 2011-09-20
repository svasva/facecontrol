class AddNeedTarget < ActiveRecord::Migration
  def change
  	add_column :actions, :need_target, :boolean, :default => false
  end
end
