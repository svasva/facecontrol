class RemoveLevelFromCharacters < ActiveRecord::Migration
  def up
  	remove_column :characters, :level
  end

  def down
  	add_column :characters, :level, :integer, :default => 0
  end
end
