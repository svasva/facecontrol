class AddTtlToActions < ActiveRecord::Migration
  def change
    add_column :actions, :ttl, :integer, :default => 0
  end
end
