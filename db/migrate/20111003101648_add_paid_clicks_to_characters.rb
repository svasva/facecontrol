class AddPaidClicksToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :paid_clicks, :integer
  end
end
