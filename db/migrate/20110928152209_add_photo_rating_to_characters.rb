class AddPhotoRatingToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :photo_rating, :integer, :default => 0
  end
end
