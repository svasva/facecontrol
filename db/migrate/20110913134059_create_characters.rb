class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name, :default => ''
      t.integer :energy, :default => 0
      t.integer :drive, :default => 0
      t.integer :glory, :default => 0
      t.integer :glamour, :default => 0
      t.integer :real_glory, :default => 0
      t.integer :money, :default => 0
      t.timestamps
    end

    
  end
end
