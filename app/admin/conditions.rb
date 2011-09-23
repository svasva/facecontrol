ActiveAdmin.register Condition do  
  belongs_to :action
  filter :name

  index do
    column :id
    column :name
    column :description
    column :created_at
    default_actions
  end



end