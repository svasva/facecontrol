class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name, :default => ''
      t.string :description, :default => ''
      t.string :picture_url, :default => ''

      t.timestamps
    end
    create_table :places_conditions, :id => false do |t|
      t.references :place, :condition
    end
    add_index :places_conditions, [:place_id, :condition_id]
  end
end
