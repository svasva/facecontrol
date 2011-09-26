ActiveAdmin.register ItemType, { :sort_order => :name_asc } do
  filter :name
  filter :description

  index do
  	column :name
  	column :description
  	column :wearable
  	column :giftable
  	column :usable
  	column :own_limit
  end

  collection_action :import_csv, :method => :post do
    ItemType.parse_csv params[:import]
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

  sidebar 'CSV import' do
    render "shared/upload"
  end
end
