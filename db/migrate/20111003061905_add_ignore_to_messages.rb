class AddIgnoreToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :ignore, :boolean, :default => false
  end
end
