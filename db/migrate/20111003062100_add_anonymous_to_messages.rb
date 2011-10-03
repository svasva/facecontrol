class AddAnonymousToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :anonymous, :boolean, :default => false
  end
end
