class CreateExchangeRates < ActiveRecord::Migration
  def change
    create_table :exchange_rates do |t|
      t.integer :social_id
      t.integer :social_price
      t.integer :game_value
      t.string :game_string

      t.timestamps
    end
  end
end
