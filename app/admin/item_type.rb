ActiveAdmin.register ItemType, { :sort_order => :name_asc } do
	filter :name
	filter :description
	menu :parent => 'Items'

	index do
		column :name
		column :description
		column :wearable do |it|
			check_box_tag '', 0, it.wearable, {:disabled => true}
		end
		column :giftable do |it|
			check_box_tag '', 0, it.giftable, {:disabled => true}
		end
		column :usable do |it|
			check_box_tag '', 0, it.usable, {:disabled => true}
		end
		column :own_limit
		column :items_count do |it|
			it.items.count.to_s
		end
		default_actions
	end

	collection_action :import_csv, :method => :post do
		ItemType.parse_csv params[:import]
		redirect_to :action => :index, :notice => "CSV imported successfully!"
	end

	sidebar 'CSV import' do
		render "shared/upload", :action => :import_csv
	end
end
