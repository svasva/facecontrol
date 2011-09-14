class CreateCharacterActions < ActiveRecord::Migration
  def change
    create_table :character_actions do |t|
      t.references :character
      t.references :action
      t.string :status, :default => 'pending'
      t.timestamp :start_time

      t.timestamps
    end
    add_index :character_actions, [:character_id, :action_id]
    add_index :character_actions, :status
  end
end
