ActiveAdmin.register Place, { :sort_order => :name_asc } do  
  filter :name
  filter :description

  index do
    column :name
    column :description
    column :actions do |place|
      div :class => "actions" do
        render "places/action_links", :place => place
      end
    end
    default_actions
  end

  collection_action :import_csv, :method => :post do
    Place.parse_csv params[:import]
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

  sidebar 'CSV import' do
    render "shared/upload", :action => :import_csv
  end


end
