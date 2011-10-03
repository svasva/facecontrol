class AddIgnoreToCharacterRelations < ActiveRecord::Migration
  def change
    add_column :character_relations, :ignore, :boolean, :default => false
  end
end
