class AddDescriptionToItemTypes < ActiveRecord::Migration
  def change
    add_column :item_types, :description, :text
  end
end
