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


  accepts_nested_attributes_for :buy_action, :gift_action, :actions, :use_action 

  after_initialize :init_default_actions
  before_create :add_names_to_default_actions

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
      build_buy_action
      build_gift_action
      build_use_action
      buy_action.conditions.build
    end
  end

  def add_names_to_default_actions
    buy_action.name = "Купить #{name}"
    gift_action.name = "Подарить #{name}"
    use_action.name = "Использовать #{name}"
  end

end
