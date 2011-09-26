class CreateCharacterRelations < ActiveRecord::Migration
  def change
    create_table :character_relations do |t|
      t.integer :character_id
      t.integer :target_id
      t.integer :index, :default => 0
      t.integer :blocked, :default => false
      t.boolean :friendship, :default => false
      t.boolean :friendship_request, :default => false

      t.timestamps
    end
    add_index :character_relations, :character_id
    add_index :character_relations, :target_id
  end
end
