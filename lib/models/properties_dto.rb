class PropertiesDTO
	attr_accessor :energy
	attr_accessor :glory
	attr_accessor :real_glory
	attr_accessor :drive
	attr_accessor :glamour
	attr_accessor :money

	def initialize(obj)
		case obj.class
		when Action.class
			@glory = obj.delta_glory
			@real_glory = obj.delta_real_glory
			@money = obj.delta_money
			@energy = obj.delta_energy
			@drive = obj.delta_drive
			@glamour = obj.subject.glamour
		end
	end
end
