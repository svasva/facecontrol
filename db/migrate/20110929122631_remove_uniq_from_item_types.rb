class RemoveUniqFromItemTypes < ActiveRecord::Migration
  def change
  	remove_column :item_types, :unique
  end
end
