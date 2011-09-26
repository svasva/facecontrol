class MessageDTO
	attr_accessor :id
	attr_accessor :source
	attr_accessor :target
	attr_accessor :content
	attr_accessor :rating
	attr_accessor :answer
	attr_accessor :has_reply

	def initialize(msg)
		@id = msg.id
		@source = msg.source.dto
		@target = msg.target.dto
		@rating = msg.rating
		@content = msg.content
		@answer = (msg.need_answer and msg.replies.count > 0) ? msg.replies.first : nil
		@has_reply = (msg.replies.count > 0)
	end
end

class Message::MessageDTO < MessageDTO
end
