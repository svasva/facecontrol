class DropItemWorker
	@queue = :DropItems
	def self.plong(str)
		puts str.gsub(/\s+/, " ").strip
	end

	def self.perform(char_item_id)
		begin
			CharacterItem.destroy(char_item_id)
		rescue => e
			puts "#{Time.now.to_s(:short)} ACHTUNG! DropItemWorker: #{e.inspect}"
		end
	end
end
