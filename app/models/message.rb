class Message < ActiveRecord::Base
	has_one :source, :class_name => 'Character', :foreign_key => 'source_id'
	has_one :target, :class_name => 'Character', :foreign_key => 'target_id'

  scope :questions, where(:need_answer => true)
  scope :rumors, where(:need_answer => false)

	def dto
		MessageDTO.new self
	end
end
