ActiveAdmin.register Character, { :sort_order => :glory_desc } do  
	filter :place
	filter :name
	filter :glory
	filter :energy
	filter :drive
	filter :real_glory
  index do
    column :name
    column :glory
    column :real_glory
    column :drive
    column :energy
    default_actions
  end
end
