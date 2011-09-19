class Action < ActiveRecord::Base
  belongs_to :subject, :polymorphic => true
<<<<<<< HEAD
  has_many :conditions
=======
  has_many :conditions, :dependent => :destroy
>>>>>>> e245cfc95fe9f96e604262c0db31b500fdd3bde7

  has_many :children,
  	:class_name => 'Action',
  	:foreign_key => 'parent_id'
    
  has_many :disabling_actions,
  	:class_name => 'Action',
  	:foreign_key => 'disabler_action_id'
  	
  belongs_to :action_group
  belongs_to :disabler_action,
  	:class_name => 'Action',
  	:foreign_key => 'disabler_action_id'

  
  #TODO add check for type uniquiness
end
