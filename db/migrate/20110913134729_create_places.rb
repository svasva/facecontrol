class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :description
      t.references :conditions
      t.string :picture_url

      t.timestamps
    end
    add_index :places, :conditions_id
  end
end
