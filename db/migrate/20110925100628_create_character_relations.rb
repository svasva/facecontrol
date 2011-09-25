class CreateCharacterRelations < ActiveRecord::Migration
  def change
    create_table :character_relations do |t|
      t.integer :character_id
      t.integer :target_id
      t.integer :index
      t.integer :blocked
      t.boolean :friendship
      t.boolean :friendship_request

      t.timestamps
    end
    add_index :character_relations, :character_id
    add_index :character_relations, :target_id
  end
end
