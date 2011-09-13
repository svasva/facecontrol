class Condition < ActiveRecord::Base
  has_and_belongs_to_many :actions
  has_and_belongs_to_many :places, :join_table => 'places_conditions'
end
