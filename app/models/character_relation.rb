class CharacterRelation < ActiveRecord::Base
	belongs_to :character
	belongs_to :target, :class_name => 'Character', :foreign_key => 'target_id'

	scope :contacts, where(:friendship => true)
	scope :contact_requests, where(:friendship => false, :friendship_request => true)
end
