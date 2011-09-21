class Item < ActiveRecord::Base
  has_many :actions, :as => :subject, :dependent => :destroy
  has_many :character_items, :dependent => :destroy
  has_one :buy_for_money_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "buy_for_money"},
    :autosave => true

  has_one :buy_for_energy_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "buy_for_energy"},
    :autosave => true

  has_one :gift_for_money_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "gift_for_money"},
    :autosave => true

  has_one :gift_for_energy_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "gift_for_energy"},
    :autosave => true


  has_one :use_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "use"},
    :autosave => true


  accepts_nested_attributes_for :buy_for_money_action, :buy_for_energy_action, :gift_for_money_action, :gift_for_energy_action, :actions, :use_action 

  after_initialize :init_default_actions
  before_save :init_use_action

  belongs_to :item_type

  def self.find_giftable
    self.all(:conditions => {:item_types => {:giftable => true}}, :joins => :item_type)
  end

  def dto
    ItemDTO.new self
  end

  private #studio

  def init_default_actions
    if new_record?
      build_buy_for_money_action
      build_buy_for_energy_action
      build_gift_for_money_action
      build_gift_for_energy_action
      build_use_action
      buy_for_money_action.conditions.build
      buy_for_energy_action.conditions.build
    end
  end

  def init_use_action
    use_action = buy_for_money_action.dup
    use_action.delta_money = 0
  end

end
