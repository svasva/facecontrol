ActiveAdmin.register Item do  
  index do
    column :name
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
end
