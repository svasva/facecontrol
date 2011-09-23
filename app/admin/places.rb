ActiveAdmin.register Place do  
  filter :name
  filter :description

  index do
    column :id
    column :name
    column :description
    column :actions do |place|
      div :class => "actions" do
        render "places/action_links", :place => place
      end
    end
    column :created_at
    column :updated_at
    default_actions
  end

  collection_action :import_csv, :method => :post do
    Place.parse_csv params[:import]
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

  sidebar 'CSV import' do
    render "shared/upload"
  end


end