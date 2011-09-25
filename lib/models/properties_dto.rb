class PropertiesDTO
	attr_accessor :energy
	attr_accessor :glory
	attr_accessor :real_glory
	attr_accessor :drive
	attr_accessor :glamour
	attr_accessor :money
	attr_accessor :operator

	@energy, @glory, @real_glory, @drive, @glamour, @money, @operator = nil

	def initialize(obj)
		case obj.class.name
		when 'Action'
			@glory = obj.delta_glory
			@real_glory = obj.delta_real_glory
			@money = obj.delta_money
			@energy = obj.delta_energy
			@drive = obj.delta_drive
		when 'Condition'
			@glory = obj.glory
			@real_glory = obj.real_glory
			@energy = obj.energy
			@drive = obj.drive
			@glamour = obj.glamour
			@money = obj.money
			@operator = obj.operator
		end
	end
end
