class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :source_id
      t.integer :target_id
      t.integer :rating
      t.boolean :need_answer

      t.timestamps
    end

    add_index :messages, :source_id
    add_index :messages, :target_id
    add_index :messages, :need_answer
  end
end
