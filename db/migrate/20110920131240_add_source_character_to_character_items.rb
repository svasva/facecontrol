class AddSourceCharacterToCharacterItems < ActiveRecord::Migration
  def up
    add_column :character_items, :source_character_id, :integer
  end

  def down
  	remove_column :character_items, :source_character_id
  end
end
