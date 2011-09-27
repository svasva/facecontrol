class AddPriseNameToActionGroups < ActiveRecord::Migration
  def change
    add_column :action_groups, :prise_name, :string
  end
end
