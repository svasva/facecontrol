ActiveAdmin.register ExchangeRate, { :sort_order => :game_value_asc } do
  filter :social_price
  filter :game_value
  filter :game_string

  index do
    column :social_price
    column :game_value
    column :game_string
    default_actions
  end

end
