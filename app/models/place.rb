class Place < ActiveRecord::Base
  has_many :actions, :as => :subject
  has_one :enter_action, :as => :subject, :class_name => 'Action'
  has_one :stay_action, :as => :subject, :class_name => 'Action'
  has_one :leave_action, :as => :subject, :class_name => 'Action'

  def self.parse_table(table)
  	
  end
end
