class Message < ActiveRecord::Base
	belongs_to :source, :class_name => 'Character', :foreign_key => 'source_id'
	belongs_to :target, :class_name => 'Character', :foreign_key => 'target_id'
	has_many :replies, :class_name => 'Message', :foreign_key => 'reply_to'

  scope :questions, where(:need_answer => true, :reply_to => nil)
  scope :rumors, where(:need_answer => false, :reply_to => nil)

	def dto
		MessageDTO.new self
	end
end
