class Message < ActiveRecord::Base
	has_one :source, :class_name => 'Character'
	has_one :target, :class_name => 'Character'

	def dto
		MessageDTO.new self
	end
end
