class CharacterDTO
	attr_accessor :id
	attr_accessor :social_id
	attr_accessor :name
	attr_accessor :sex
	attr_accessor :level
	attr_accessor :glory
	attr_accessor :glamour
	attr_accessor :real_glory
	attr_accessor :relation
	attr_accessor :money
	attr_accessor :energy
	attr_accessor :drive
	attr_accessor :place
	attr_accessor :max_energy
	attr_accessor :next_level_glory

	def initialize(char, target_char_id = nil)
		@id = char.id
		@max_energy = char.max_energy
		@social_id = char.social_id
		@name = char.name
		@glamour = char.glamour
		@sex = char.male
		@level = char.level
		@glory = char.glory
		@real_glory = char.real_glory
		if target_char_id
			rel = char.relations.where(:target_id => target_char_id).first
			@relation = rel ? rel.relation_index : nil
		end
		@money = char.money
		@energy = char.energy
		@drive = char.drive
		@place = char.place_id
		@next_level_glory = char.glory_for_next_level
	end
end

class Character::CharacterDTO < CharacterDTO
end
