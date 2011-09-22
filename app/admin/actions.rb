ActiveAdmin.register Action do  
  belongs_to :place

  index do
    column :id
    column :name
    column :description
    column :created_at
    column :updated_at
    default_actions
  end



end