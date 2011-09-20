class AddPolymorphicAssociationsToAction < ActiveRecord::Migration
  def change
  	add_column :actions, :subject_id, :integer
  	add_column :actions, :subject_type, :string
  	add_index :actions, [:subject_id, :subject_type]
  end
end
