class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :energy
      t.integer :drive
      t.integer :glory
      t.integer :real_glory

      t.timestamps
    end
  end
end
