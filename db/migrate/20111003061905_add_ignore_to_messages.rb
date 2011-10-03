class AddIgnoreToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :ignore, :boolean
  end
end
