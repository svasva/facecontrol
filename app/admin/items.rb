ActiveAdmin.register Item do
	filter :item_type, :collection => ItemType.all.map {|i| ["#{i.name} (#{i.description})", i.id]}
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

end
