class AddSexAndLevelToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :sex, :boolean
    add_column :characters, :level, :integer, :default => 1
  end
end
