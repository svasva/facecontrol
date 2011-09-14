class Action < ActiveRecord::Base
  has_and_belongs_to_many :conditions
  has_many :children, :class_name => 'Action', :foreign_key => 'parent_id'
  belongs_to :action_group
  has_one :disabler_action, :class_name => 'Action', :foreign_key => 'disabler_action_id'
end
