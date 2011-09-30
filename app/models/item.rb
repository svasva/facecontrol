# encoding: utf-8

class Item < ActiveRecord::Base
  has_many :actions, :as => :subject, :dependent => :destroy
  has_many :character_items, :dependent => :destroy
  has_one :buy_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "buy"},
    :autosave => true

  has_one :gift_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "gift"},
    :autosave => true

  has_one :use_action,
    :as => :subject,
    :class_name => 'Action',
    :conditions => {:default_type => "use"},
    :autosave => true

  scope :giftable, lambda { joins(:item_type).where(:item_types => {:giftable => true, :usable => false}) }
  scope :wearable, lambda { joins(:item_type).where(:item_types => {:wearable => true, :usable => false}) }
  scope :usable,   lambda { joins(:item_type).where(:item_types => {:usable => true, :giftable => true}) }

  accepts_nested_attributes_for :buy_action, :gift_action, :actions, :use_action 

  belongs_to :item_type

  def dto
    ItemDTO.new self
  end


  def set_type_by_name(type_name)
    self.item_type = ItemType.find_by_name(type_name)
    build_buy_action(:name => "Купить #{name}") unless type_name == 'gift'
    #FIXME It musn't be harcoded type
    build_gift_action(:name => "Подарить #{name}") if item_type.giftable 
    build_use_action(:name => "Использовать #{name}") if item_type.usable
  end
 

  include Models::Item::CsvExchange

end
