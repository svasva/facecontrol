require 'character_dto.rb'

class MessageDTO
	attr_accessor :id
	attr_accessor :source
	attr_accessor :target
	attr_accessor :content

	@id, @source, @target, @content = nil;

	def initialize(msg)
		@id = msg.id
		@source = CharacterDTO.new msg.source
		@target = CharacterDTO.new msg.target
		@content = msg.content
	end
end
