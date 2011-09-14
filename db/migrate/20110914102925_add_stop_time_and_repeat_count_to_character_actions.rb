class AddStopTimeAndRepeatCountToCharacterActions < ActiveRecord::Migration
  def change
    add_column :character_actions, :stop_time, :timestamp
    add_column :character_actions, :repeat_count, :integer, :default => 0
  end
end
