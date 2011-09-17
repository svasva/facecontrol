class AddPolymorphicAssociationsToAction < ActiveRecord::Migration
  def change
  	add_column :actions, :subject_id, :integer
  	add_column :actions, :subject_type, :string

  	#TODO index

  	#cleunup obsolate relations
  	drop_table :places_conditions
  	remove_column :items, :conditions_id
  end
end
