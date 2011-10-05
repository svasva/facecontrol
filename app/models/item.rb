# encoding: utf-8

class Item < ActiveRecord::Base
  belongs_to :item_type
  has_many :game_actions, :as => :subject, :dependent => :destroy
  has_many :character_items, :dependent => :destroy
  has_one :buy_action,
    :as => :subject,
    :class_name => 'GameAction',
    :conditions => {:default_type => "buy"},
    :autosave => true

  has_one :buy_for_gold_action,
    :as => :subject,
    :class_name => 'GameAction',
    :conditions => {:default_type => "buy_for_gold"},
    :autosave => true

  has_one :gift_action,
    :as => :subject,
    :class_name => 'GameAction',
    :conditions => {:default_type => "gift"},
    :autosave => true

  has_one :gift_for_gold_action,
    :as => :subject,
    :class_name => 'GameAction',
    :conditions => {:default_type => "gift_for_gold"},
    :autosave => true

  has_one :use_action,
    :as => :subject,
    :class_name => 'GameAction',
    :conditions => {:default_type => "use"},
    :autosave => true

  scope :giftable, joins(:item_type).where(:item_types => {:giftable => true, :usable => false})
  scope :wearable, joins(:item_type).where(:item_types => {:wearable => true, :usable => false})
  scope :usable, joins(:item_type).where(:item_types => {:usable => true, :giftable => true})
  scope :by_type_names, lambda {|names| joins(:item_type).where(:item_types => {:name => names})}

  accepts_nested_attributes_for :use_action,
                                :buy_action,
                                :buy_for_gold_action,
                                :gift_action,
                                :gift_for_gold_action,
                                :game_actions

  after_initialize :init_actions
  before_save :before_save_hook

  def init_actions
    if new_record? #Kinda after_new callback
      build_buy_action(:name => "Купить #{self.name}")
      build_gift_action(:name => "Подарить #{self.name}")
      build_use_action(:name => "Использовать #{self.name}")
    end
  end

  def before_save_hook
    remove_spare_actions
    set_gold_actions
  end

  def remove_spare_actions
    if self.item_type.name == 'gift'
      # remove buy action
      self.buy_action = nil
      self.buy_for_gold_action = nil
    end
    unless self.item_type.usable
      # remove use action
      self.use_action = nil
    end
    unless self.item_type.giftable
      # remove gift action
      self.gift_action = nil
      self.gift_for_gold_action = nil
    end
  end

  def set_gold_actions
    if self.buy_action and self.buy_action.delta_money == 0
      build_buy_for_gold_action(self.buy_action.dup.attributes)
      buy_for_gold_action.name = "Купить #{self.name} (gold)"
      buy_for_gold_action.delta_money = self.buy_action.delta_energy / FCconfig.energy_gold_ratio
      buy_for_gold_action.default_type = 'buy_for_gold'
    end
    if self.gift_action and self.gift_action.delta_money == 0
      build_gift_for_gold_action(self.gift_action.dup.attributes)
      gift_for_gold_action.name = "Подарить #{self.name} (gold)"
      gift_for_gold_action.delta_money = self.gift_action.delta_energy / FCconfig.energy_gold_ratio
      buy_for_gold_action.default_type = 'gift_for_gold'
    end
  end

  def dto
    ItemDTO.new self
  end

  def set_type_by_name(type_name)
    self.item_type = ItemType.find_by_name(type_name)
  end
 
  include Models::Item::CsvExchange

end
