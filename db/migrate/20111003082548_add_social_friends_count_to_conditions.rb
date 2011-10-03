class AddSocialFriendsCountToConditions < ActiveRecord::Migration
  def change
    add_column :conditions, :social_friends_count, :integer
  end
end
