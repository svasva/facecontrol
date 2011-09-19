class AddActionType < ActiveRecord::Migration
  def change
  	add_column :actions, :default_type, :string
  end
end
