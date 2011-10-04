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

  form do |f|
    f.inputs 'Place' do
      f.input :name
      f.input :description
      f.input :picture_url
      f.input :map_x
      f.input :map_y
      f.input :video_urls
      f.input :actions,
        :collection => GameAction.all.map {|a| ["#{a.name} (#{a.description})", a.id]}
    end
    f.buttons
  end

  collection_action :import_csv, :method => :post do
    Place.parse_csv params[:import]
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

  collection_action :export, :method => :get do
    respond_to do |f| 
      f.csv {
          send_data Place.generate_csv, 
            :type => 'text/csv; charset=utf-8; header=present', 
            :disposition => "attachment; filename=places.csv"  
          }
    end
  end

  sidebar 'CSV import' do
    render "shared/upload", :action => :import_csv
  end


end
