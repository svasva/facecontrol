class CreateCharacterRelations < ActiveRecord::Migration
  def change
    create_table :character_relations do |t|
      t.integer :character_id
      t.integer :target_id
      t.integer :index, :default => 0
      t.integer :blocked, :default => 0
      t.boolean :friendship, :default => 0
      t.boolean :friendship_request, :default => 0

      t.timestamps
    end
    add_index :character_relations, :character_id
    add_index :character_relations, :target_id
  end
end
