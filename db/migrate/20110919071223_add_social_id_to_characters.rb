class AddSocialIdToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :social_id, :string
  end

  add_index :characters, :social_id
end
