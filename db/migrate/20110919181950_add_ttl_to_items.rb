class AddTtlToItems < ActiveRecord::Migration
  def change
    add_column :items, :ttl, :integer, :default => 0
  end
end
