ActiveAdmin.register CharacterActionGroup, { :sort_order => :action_group_rating_desc } do
  menu :label => 'Contest stats'
  
  filter :action_group
  filter :action_group_rating
  filter :created_at

  index do
    column :action_group
    column :character
    column :action_group_rating
    column :created_at

    default_actions
  end
end
