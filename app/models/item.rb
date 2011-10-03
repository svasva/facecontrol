# encoding: utf-8

class Item < ActiveRecord::Base
  has_many :actions, :as => :subject, :dependent => :destroy
  has_many :character_items, :dependent => :destroy
  has_one :buy_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "buy"},
    :autosave => true

  has_one :buy_for_gold_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "buy_for_gold"},
    :autosave => true

  has_one :gift_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "gift"},
    :autosave => true

  has_one :gift_for_gold_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "gift_for_gold"},
    :autosave => true

  has_one :use_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "use"},
    :autosave => true

  scope :giftable, joins(:item_type).where(:item_types => {:giftable => true, :usable => false})
  scope :wearable, joins(:item_type).where(:item_types => {:wearable => true, :usable => false})
  scope :usable, joins(:item_type).where(:item_types => {:usable => true, :giftable => true})
  scope :by_type_names, lambda {|names| joins(:item_type).where(:item_types => {:name => names})}

  accepts_nested_attributes_for :buy_action, :gift_action, :actions, :use_action 

  belongs_to :item_type

  def dto
    ItemDTO.new self
  end


  def set_type_by_name(type_name)
    self.item_type = ItemType.find_by_name(type_name)

    build_buy_action(:name => "Купить #{self.name}") unless type_name == 'gift'
    #FIXME It shouldn't be harcoded type
    build_buy_for_gold_action(:name => "Купить #{self.name} (gold)") unless type_name == 'gift'
    build_gift_action(:name => "Подарить #{self.name}") if item_type.giftable
    build_gift_for_gold_action(:name => "Подарить #{self.name} (gold)") if item_type.giftable
    build_use_action(:name => "Использовать #{self.name}") if item_type.usable
  end
 

  include Models::Item::CsvExchange

end
