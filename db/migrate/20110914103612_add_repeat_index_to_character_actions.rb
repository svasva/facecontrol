class AddRepeatIndexToCharacterActions < ActiveRecord::Migration
  def change
    add_column :character_actions, :repeat_index, :integer, :default => 1
  end
end
