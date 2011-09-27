class AddFieldsToActionGroups < ActiveRecord::Migration
  def change
    add_column :action_groups, :end_time, :timestamp
    add_column :action_groups, :price, :integer
    add_column :action_groups, :image_url, :string
  end
end
