class CharacterActionWorker
	@queue = :CharacterActions
	def self.plong(str)
		puts str.gsub(/\s+/, " ").strip
	end

	def self.perform(ca_id)
		ca = CharacterAction.find(ca_id)
		plong "= performing action #{ca.action.name}(#{ca.action.id}) \
					for #{ca.character.id} ="
  	begin
			if ca.status != 'canceled'
				ca.process_action ? ca.done! : ca.failed!
			else
				puts "#{ca.action.name}(#{ca.action.id}) was canceled"
			end
		rescue => e
			puts e.inspect
			ca.failed!
			puts "#{ca.action.name}(#{ca.action.id}) FALIED!!!11 OMGWTF"
		end
	end
end
