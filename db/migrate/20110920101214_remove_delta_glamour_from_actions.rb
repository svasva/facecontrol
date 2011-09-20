class RemoveDeltaGlamourFromActions < ActiveRecord::Migration
  def up
		remove_column :actions, :delta_glamour
  end

  def down
		add_column :actions, :delta_glamour, :integer
  end
end
