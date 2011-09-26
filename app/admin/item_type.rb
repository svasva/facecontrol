ActiveAdmin.register ItemType do
  filter :name

  collection_action :import_csv, :method => :post do
    ItemType.parse_csv params[:import]
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

  sidebar 'CSV import' do
    render "shared/upload"
  end
end
