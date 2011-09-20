class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content, :default => ''
      t.integer :source_id
      t.integer :target_id
      t.integer :rating, :default => 0
      t.boolean :need_answer, :default => false

      t.timestamps
    end

    add_index :messages, :source_id
    add_index :messages, :target_id
    add_index :messages, :need_answer
  end
end
