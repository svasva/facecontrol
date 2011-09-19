class MessageDTO
	attr_accessor :id
	attr_accessor :source
	attr_accessor :target
	attr_accessor :content

	@id, @source, @target, @content = nil;

	def initialize(msg)
		@id = msg.id
		@source = msg.source.amf
		@target = msg.target.amf
		@content = msg.content
	end
end
