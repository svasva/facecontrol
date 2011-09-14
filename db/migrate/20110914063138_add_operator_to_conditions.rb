class AddOperatorToConditions < ActiveRecord::Migration
  def change
    add_column :conditions, :operator, :string, :default => '>='
  end
end
