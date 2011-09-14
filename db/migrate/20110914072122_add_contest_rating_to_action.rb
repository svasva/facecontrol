class AddContestRatingToAction < ActiveRecord::Migration
  def change
    add_column :actions, :contest_rating, :integer, :default => 0
  end
end
