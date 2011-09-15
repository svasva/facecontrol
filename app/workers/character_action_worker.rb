class CharacterActionWorker
	@queue = :CharacterActions

	def self.perform(ca_id)
		ca = CharacterAction.find(ca_id)
		puts "= performing action #{ca.action.name}(#{ca.action.id}) for #{ca.character.id} ="
  	begin
			if ca.status == 'canceled'
				puts "#{ca.action.name}(#{ca.action.id}) was canceled"
			else
				ca.process_action ? ca.done! : ca.failed!
			end
		rescue => e
			puts e.inspect
			ca.failed!
			puts "#{ca.action.name}(#{ca.action.id}) FALIED!!!11 OMGWTF"
		end
	end
end
