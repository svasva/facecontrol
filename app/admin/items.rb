ActiveAdmin.register Item do  
  index do
    column :name
    default_actions
  end
collection_action :import_csv, :method => :post do
    Item.parse_csv params[:import]
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

end