ActiveAdmin.register Item do
	filter :item_type
	filter :name
	filter :description
	filter :glamour

  index do
    column :name
    column :description
    column :glamour
    column :actions do |item|
      div :class => "actions" do
        render "items/action_links", :item => item
      end
    end
    default_actions
  end
	collection_action :import_csv, :method => :post do
    Item.parse_csv params[:import]
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

  form do |f|
  	f.inputs 'Item' do
	    f.input :name
	    f.input :description
	    f.input :picture_url
	    f.input :ttl
	    f.input :wear_factor
	    f.input :glamour
	    f.input :item_type,
	    	:collection => ItemType.all.map {|i| ["#{i.name} (#{i.description})", i.id]}
      f.input :game_actions,
        :collection => GameAction.all.map {|a| ["#{a.name} (#{a.description})", a.id]}
	    f.input :sex
	  end
    f.buttons
  end

  collection_action :import_drinks_csv, :method => :post do
    Item.parse_drinks_csv params[:import]
    redirect_to :action => :index, :notice => "CSV with drinks imported successfully!"
  end

  collection_action :import_clothes_csv, :method => :post do
    Item.parse_clothes_csv params[:import]
    redirect_to :action => :index, :notice => "CSV with clothes imported successfully!"
  end

  collection_action :import_gifts_csv, :method => :post do
    Item.parse_gifts_csv params[:import]
    redirect_to :action => :index, :notice => "CSV with gifts imported successfully!"
  end

  sidebar 'CSV drinks import' do
    render "shared/upload", :action => :import_drinks_csv
  end
  sidebar 'CSV gifts import' do
    render "shared/upload", :action => :import_gifts_csv
  end
  sidebar 'CSV clothes import' do
    render "shared/upload", :action => :import_clothes_csv
  end

  collection_action :drinks, :method => :get do
    respond_to do |f| 
      f.csv {
         send_data Item.generate_drink_csv, 
            :type => 'text/csv; charset=utf-8; header=present', 
            :disposition => "attachment; filename=drinks.csv"  
          }
    end
  end

  collection_action :gifts, :method => :get do
    respond_to do |f| 
      f.csv {
         send_data Item.generate_gift_csv, 
            :type => 'text/csv; charset=utf-8; header=present', 
            :disposition => "attachment; filename=gifts.csv"  
          }
    end
  end

  collection_action :clothes, :method => :get do
    respond_to do |f| 
      f.csv {
         send_data Item.generate_cloth_csv, 
            :type => 'text/csv; charset=utf-8; header=present', 
            :disposition => "attachment; filename=clothes.csv"  
          }
    end
  end
end
