class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name, :default => ''
      t.string :description, :default => ''
      t.string :picture_url, :default => ''

      t.timestamps
    end
  end
end
