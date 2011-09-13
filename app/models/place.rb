class Place < ActiveRecord::Base
  has_and_belongs_to_many :conditions, :join_table => 'places_conditions'

end
