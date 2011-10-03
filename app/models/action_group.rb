# encoding: utf-8

class ActionGroup < ActiveRecord::Base
	has_many :actions
  after_initialize :init_default_actions
  before_create :add_names_to_default_actions

  has_one :enter_action,
		:as => :subject,
		:class_name => 'Action',
		:conditions => {:default_type => "enter_action_group"},
	  :autosave => true,
	  :dependent => :destroy

	def dto(char = nil)
		ActionGroupDTO.new self, char
	end

	def leaders
		Character.ag_leaders(self.id)
	end
	
	protected

  def init_default_actions
		if new_record?
			build_enter_action
			enter_action.conditions.build
		end
  end

  def add_names_to_default_actions
		enter_action.name = "Принять участие в #{name}"
  end
end
