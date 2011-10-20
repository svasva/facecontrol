ActiveAdmin.register CharacterActionGroup, { :sort_order => :action_group_rating_desc } do
  menu :label => 'Contest stats'

  filter :action_group
  filter :action_group_rating
  filter :created_at

  index do
    column "Contest", :action_group
    column :character
    column "rating", :action_group_rating
    column "entered at", :created_at
  end
end
