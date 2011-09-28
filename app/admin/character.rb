ActiveAdmin.register Character, { :sort_order => :glory_desc } do  
	filter :place, :collection => Place.order('name asc')
	filter :name
	filter :glory
	filter :energy
  filter :money
	filter :drive
	filter :real_glory
  index do
    column :name
    column :glory
    column :real_glory
    column :drive
    column :energy
    column :money
    default_actions
  end
end
