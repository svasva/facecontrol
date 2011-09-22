class Condition < ActiveRecord::Base
  belongs_to :action

  def dto
  	PropertiesDTO.new self
  end
end
