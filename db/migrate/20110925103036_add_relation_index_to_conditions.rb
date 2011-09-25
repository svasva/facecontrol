class AddRelationIndexToConditions < ActiveRecord::Migration
  def change
    add_column :conditions, :relation_index, :integer
  end
end
