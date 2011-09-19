class Message < ActiveRecord::Base
	has_one :source, :class_name => 'Character'
	has_one :target, :class_name => 'Character'

	def amf
		self.to_amf(:except => [:updated_at, :created_at, :need_answer])
	end
end
