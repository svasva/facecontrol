class AddReplyToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :reply_to, :integer
    add_index :messages, :reply_to
  end
end
