ActiveAdmin.register CharacterActionGroup do
  menu :label => 'Contest stats'
  index do
    column :action_group
    column :character
    column :action_group_rating
    column :created_at

    default_actions
  end
end
