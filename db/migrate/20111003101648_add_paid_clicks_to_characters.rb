class AddPaidClicksToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :paid_clicks, :integer, :default => 0
  end
end
