class AddPlaceToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :place_id, :integer
    add_index :characters, :place_id
  end
end
