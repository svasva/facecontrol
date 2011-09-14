class CharacterActionWorker
	@queue = :CharacterActions

	def self.perform()
		charactions = CharacterAction.where :status => :pending
		puts charactions.to_yaml
		charactions.each {|charaction|
  		puts "= starting action #{charaction.action.name}(#{charaction.action.id}) for #{charaction.character.id} ="
    	begin	
				charaction.process_action ? charaction.processed! : charaction.failed!
			rescue => e
				puts e.inspect
				charaction.failed!
				puts "#{charaction.action.name}(#{charaction.action.id}) FALIED!!!11 OMGWTF"
			end
		}
	end
end
