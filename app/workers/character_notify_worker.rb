class CharacterNotifyWorker
	@queue = :CharacterNotifications
	def self.plong(str)
		puts str.gsub(/\s+/, " ").strip
	end

	def self.perform(text)
		Character.find_in_batches(:select => :social_id, :batch_size => 100) {|group|
			FCconfig.vk_session.secure.sendNotification :uids => group.map(&:social_id).join(','),
																									:message => text,
																									:timestamp => Time.now.to_i
		}
	end
end
