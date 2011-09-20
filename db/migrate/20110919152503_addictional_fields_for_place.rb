class AddictionalFieldsForPlace < ActiveRecord::Migration
  def change
  	add_column :places, :map_x, :integer
  	add_column :places, :map_y, :integer
  	add_column :places, :video_urls, :text
  end
end
