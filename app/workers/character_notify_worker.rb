class CharacterNotifyWorker
	@queue = :CharacterNotifications
	def self.perform(sn_id)
		begin
			return false unless (sn = SocialNotification.find(sn_id))
			puts "PROCESSING SocialNotification ##{sn.id}"
			sn.start!
			Character.notify_all(sn.message) {|count, position|
				puts "#{(position.to_f / (count.to_f/100.0)).round}% (#{position} of #{count}) done"
				sn.update_attributes(
					:progress => "#{(position.to_f / (count.to_f/100.0)).round}% (#{position} of #{count}) done"
				)
			}
			sn.done!
		rescue => e
			sn.failed!
			puts "#{Time.now.to_s(:short)} ACHTUNG! CharacterNotifyWorker failed while sending #{sn.inspect}:\n#{e.inspect}"
		end
	end
end
