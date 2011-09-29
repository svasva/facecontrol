class Action < ActiveRecord::Base

  belongs_to :parent, :class_name => 'Action'
  belongs_to :subject, :polymorphic => true
  has_many :conditions, :dependent => :destroy
  has_many :character_actions, :dependent => :destroy

  accepts_nested_attributes_for :conditions

  has_many :children,
  	:class_name => 'Action',
  	:foreign_key => 'parent_id'
    
  has_one :disabler_action,
  	:class_name => 'Action',
  	:foreign_key => 'disabler_action_id'
  	
  belongs_to :action_group

  scope :by_place, lambda {|place_id|
    where :subject_id => place_id, :subject_type => 'Place'
  }

  scope :post_rumor, :conditions => {:default_type => 'post_rumor'}
  scope :post_question, :conditions => {:default_type => 'post_question'}
  scope :post_reply, :conditions => {:default_type => 'post_reply'}
  scope :vote, :conditions => {:default_type => 'vote'}

  def dto
    PropertiesDTO.new self
  end
 
  before_save :add_default_condition

  protected

  def add_default_condition
    attrs = %w'energy money drive glory real_glory'
    if attrs.any? { |attr| self["delta_#{attr}"] < 0 }
      default_condition = Condition.new({:name => "default_condition"})
      attrs.each do |attr|
        #FIXME Refactor
        if self["delta_#{attr}"] < 0
          default_condition[attr] = -self["delta_#{attr}"]
        end
      end
      self.conditions = [default_condition]
    end
  end
  # validates :default_type,
  #   :uniqueness => {:scope => [:subject_type, :subject_id]}
end
