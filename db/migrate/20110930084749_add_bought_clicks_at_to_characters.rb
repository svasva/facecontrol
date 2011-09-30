class AddBoughtClicksAtToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :bought_clicks_at, :timestamp
  end
end
