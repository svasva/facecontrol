class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :from_id
      t.integer :to_id
      t.integer :rating
      t.boolean :need_answer

      t.timestamps
    end

    add_index :messages, :from_id
    add_index :messages, :to_id
  end
end
