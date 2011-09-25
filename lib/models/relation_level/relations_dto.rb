class RelationsDTO
	attr_accessor :allow_travel
	attr_accessor :allow_friendship_request

	def initialize(relationlevels)
		@allow_travel = nil
		@allow_friendship_request = nil
		relationlevels.each {|l|
			@allow_travel = l.relation_index if l.allow_travel
			@allow_friendship_request = l.relation_index if l.allow_friendship_request
		}
	end
end

class RelationLevel::RelationsDTO < RelationsDTO
end
