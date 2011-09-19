class AddTtlToItems < ActiveRecord::Migration
  def change
    add_column :items, :ttl, :integer
  end
end
