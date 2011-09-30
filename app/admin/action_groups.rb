ActiveAdmin.register ActionGroup do  
  menu :parent => 'Actions'
	filter :name
  filter :description
  filter :start_time
  filter :end_time
  index do
    column :name
    column :price
    column :prise_name
    column :image_url
    column :start_time
    column :end_time
    default_actions
  end
end
