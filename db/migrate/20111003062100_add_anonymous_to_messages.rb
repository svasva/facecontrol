class AddAnonymousToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :anonymous, :boolean
  end
end
