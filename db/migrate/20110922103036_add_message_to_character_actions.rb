class AddMessageToCharacterActions < ActiveRecord::Migration
  def change
    add_column :character_actions, :message_id, :integer
  end
end
