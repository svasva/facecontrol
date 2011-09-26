class Message < ActiveRecord::Base
	belongs_to :source, :class_name => 'Character', :foreign_key => 'source_id'
	belongs_to :target, :class_name => 'Character', :foreign_key => 'target_id'

  scope :questions, where(:need_answer => true)
  scope :rumors, where(:need_answer => false)

	def dto
		MessageDTO.new self
	end
end
