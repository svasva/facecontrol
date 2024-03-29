ActiveAdmin.register GloryLevel, { :sort_order => :level_asc } do
	menu :parent => 'Characters'
  filter :level
  filter :glory
  filter :max_energy

  index do
    column :level
    column :glory
    column :max_energy
    default_actions
  end

end
