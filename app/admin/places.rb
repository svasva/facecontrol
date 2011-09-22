ActiveAdmin.register Place do  

  index do
    column :id
    column :name
    column :description
    column :actions do |place|
      div :class => "actions" do
        o =  place.actions.inject("") do |foo, a|
          foo << link_to("#{a.name} (#{a.id.to_s})", admin_place_action_path(place, a))
          foo << "<br>"
        end
        raw o
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