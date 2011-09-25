class CharacterRelation < ActiveRecord::Base
	belongs_to :character
	belongs_to :target, :class_name => 'Character', :foreign_key => 'target_id'
end
