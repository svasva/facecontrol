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

   form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :description
      f.input :prise_name
      f.input :price
      f.input :image_url
    end
    f.inputs "Timings" do
      f.input :start_time, :input_html => { :class => 'disable-chosen'}
      f.input :end_time, :input_html => {:class => 'disable-chosen' }
    end
    f.buttons   
  end
  
end
