class CharacterDTO
	attr_accessor :id
	attr_accessor :social_id
	attr_accessor :name
	attr_accessor :sex
	attr_accessor :level
	attr_accessor :glory
	attr_accessor :real_glory
	attr_accessor :liking
	attr_accessor :money
	attr_accessor :energy
	attr_accessor :drive

	@id, @social_id, @name, @sex, @glory, @real_glory, @liking, @energy, @drive = nil;

	def initialize(char)
		@id = char.id
		@social_id = char.social_id
		@name = char.name
		@sex = char.sex
		@level = char.level
		@glory = char.glory
		@real_glory = char.real_glory
		@liking = nil
		@money = char.money
		@energy = char.energy
		@drive = char.drive
	end
end
