# encoding: utf-8

class Place < ActiveRecord::Base
  has_many :actions, :as => :subject

  has_one :enter_action, :as => :subject, :class_name => 'Action', :conditions => {:type => "enter"}
  has_one :stay_action, :as => :subject, :class_name => 'Action', :conditions => {:type => "stay"}
  has_one :leave_action, :as => :subject, :class_name => 'Action', :conditions => {:type => "leave"}

  accepts_nested_attributes_for :enter_action, :stay_action, :leave_action, :actions

  after_initialize :init_default_actions


  private #studio

  def init_default_actions
	build_enter_action
  	build_stay_action
   	build_leave_action 	
  end
end
