ActiveAdmin.register Action do  
  belongs_to :place
  filter :name

  index do
    column :id
    column :name
    column :description
	column :conditions do |action|
      div :class => "actions" do
        render "actions/condition_links", :action => action
      end
    end
    column :created_at
    default_actions
  end
end