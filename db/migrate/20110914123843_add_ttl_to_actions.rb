class AddTtlToActions < ActiveRecord::Migration
  def change
    add_column :actions, :ttl, :integer
  end
end
