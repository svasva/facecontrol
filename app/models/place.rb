# encoding: utf-8

class Place < ActiveRecord::Base
  has_many :actions, :as => :subject

  has_one :enter_action,
		:as => :subject,
		:class_name => 'Action',
		:conditions => {:default_type => "enter"},
	  :autosave => true,
	  :dependent => :destroy

  has_one :stay_action,
  	:as => :subject,
  	:class_name => 'Action',
		:conditions => {:default_type => "stay"},
		:autosave => true,
		:dependent => :destroy

  has_one :leave_action,
  	:as => :subject,
  	:class_name => 'Action',
  	:conditions => {:default_type => "leave"},
  	:autosave => true,
  	:dependent => :destroy

  accepts_nested_attributes_for :enter_action, :stay_action, :leave_action, :actions

  after_initialize :init_default_actions
  before_create :add_names_to_default_actions


  private #studio

  def init_default_actions
		if new_record?
			build_enter_action
			build_stay_action
			build_leave_action
			enter_action.conditions.build	
		end
  end

  def add_names_to_default_actions
		enter_action.name = "Войти в #{name}"
		stay_action.name = "Находится в #{name}"
		leave_action.name = "Выйти из #{name}"
  end

  include Models::Place::CsvExchange

end
