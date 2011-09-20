class Item < ActiveRecord::Base
  has_many :actions, :as => :subject, :dependent => :destroy
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

  has_one :gift_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "gift"},
    :autosave => true

  accepts_nested_attributes_for :buy_for_money_action, :buy_for_energy_action, :gift_action, :actions

  after_initialize :init_default_actions

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
      build_gift_action
      buy_for_money_action.conditions.build
      buy_for_energy_action.conditions.build
    end
  end

end
