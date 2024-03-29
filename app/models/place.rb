# encoding: utf-8

class Place < ActiveRecord::Base
  has_many :game_actions, :as => :subject, :dependent => :destroy
  has_many :characters

  has_one :enter_action,
		:as => :subject,
		:class_name => 'GameAction',
		:conditions => {:default_type => "enter"},
	  :autosave => true

  has_one :stay_action,
  	:as => :subject,
  	:class_name => 'GameAction',
		:conditions => {:default_type => "stay"},
		:autosave => true

  has_one :leave_action,
  	:as => :subject,
  	:class_name => 'GameAction',
  	:conditions => {:default_type => "leave"},
  	:autosave => true
    
  accepts_nested_attributes_for :enter_action, :stay_action, :leave_action, :game_actions

  after_initialize :init_default_actions
  before_create :add_names_to_default_actions
  
  def dto(char = nil)
    PlaceDTO.new self, char
  end

  def club_dto(char = nil)
    ClubDTO.new self, char
  end

  def last_visitors_dto(my_char_id = nil, limit = 50)
    CharacterAction.char_uniq.where(:game_action_id => self.enter_action.id)
      .where{character_id != my_char_id}
      .order('id DESC')
      .limit(limit)
      .map {|ca| ca.character.dto(my_char_id)}
  end

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
		stay_action.name = "Находиться в #{name}"
		leave_action.name = "Выйти из #{name}"
  end

  include Models::Place::CsvExchange

  
  default_scope includes(:game_actions) 

end
