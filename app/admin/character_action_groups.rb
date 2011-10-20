ActiveAdmin.register CharacterActionGroup do
  menu :label => 'Contest stats'
  index do
    colimn :action_group
    column :character
    column :action_group_rating
    column :created_at

    default_actions
  end
end
