class AddSexToItems < ActiveRecord::Migration
  def change
  	add_column :items, :sex, :boolean
  end
end
