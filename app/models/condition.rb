class Condition < ActiveRecord::Base
  belongs_to :game_action

  def dto
  	PropertiesDTO.new self
  end
end
