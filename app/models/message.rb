class Message < ActiveRecord::Base
	has_one :source, :class_name => 'Character'
	has_one :target, :class_name => 'Character'

	def amf
		self.to_amf(
			:except => [
				:source_id,
				:target_id,
				:updated_at,
				:created_at,
				:need_answer
			],
			:include => [:source, :target]
		)
	end
end
