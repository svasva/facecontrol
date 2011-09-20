class Item < ActiveRecord::Base
  has_many :actions, :as => :subject
  has_one :buy_action,
		:as => :subject,
		:class_name => 'Action',
		:conditions => {:default_type => "buy"},
		:autosave => true

  has_one :wear_action,
		:as => :subject,
		:class_name => 'Action',
		:conditions => {:default_type => "wear"},
		:autosave => true

  has_one :take_off_action,
		:as => :subject,
		:class_name => 'Action',
		:conditions => {:default_type => "take_off"},
		:autosave => true

  has_one :gift_action,
		:as => :subject,
		:class_name => 'Action',
		:conditions => {:default_type => "gift"},
		:autosave => true

  accepts_nested_attributes_for :buy_action, :wear_action, :take_off_action, :gift_action, :actions

  after_initialize :init_default_actions

  has_one :item_type
  def dto
    ItemDTO.new self
  end

  private #studio

  def init_default_actions
		if new_record?
			build_buy_action
			build_wear_action
			build_take_off_action
			build_gift_action
			buy_action.conditions.build
		end
  end

end
