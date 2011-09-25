class AddRelationIndexToActions < ActiveRecord::Migration
  def change
    add_column :actions, :delta_relation_index, :integer
  end
end
