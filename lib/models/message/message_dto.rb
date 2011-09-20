class MessageDTO
	attr_accessor :id
	attr_accessor :source
	attr_accessor :target
	attr_accessor :content
	attr_accessor :rating

	@id, @source, @target, @content = nil;

	def initialize(msg)
		@id = msg.id
		@source = msg.source.dto
		@target = msg.target.dto
		@rating = msg.rating
		@content = msg.content
	end
end

class Message::MessageDTO < MessageDTO
end
