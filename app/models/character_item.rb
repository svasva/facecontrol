class CharacterItem < ActiveRecord::Base
  belongs_to :character
  belongs_to :source_character, :class_name => 'Character'
  belongs_to :item
  delegate :use_action, :to => :item

  scope :gifts, joins({:item => :item_type}).where(
    :gift => true,
    :item => {
      :item_type => { :giftable => true, :usable => false }
    }
  )

  scope :clothes, joins({:item => :item_type}).where(
    :gift => false,
    :item => {
      :item_type => { :giftable => false, :usable => false, :wearable => true }
    }
  )

  scope :gift_drinks, joins({:item => :item_type}).where(
    :gift => true,
    :item => {
      :item_type => { :giftable => true, :usable => true, :wearable => false }
    }
  )

  scope :equipped, where(:equipped => true)

  after_create :drop_after_ttl

  def glamour
    self.item.glamour - (self.wear * self.item.wear_factor) if self.item.glamour
  end

  def gift_dto
  	GiftDTO.new self
  end

  def dto
    CharacterItemDTO.new self
  end

  def find_same_type_eq
  	CharacterItem.find(
  		:all,
  		:conditions => {
	  		:character_id => self.character_id,
	  		:equipped => true,
	  		:items => {:item_type_id => self.item.item_type_id}
	  	},
	  	:joins => {:item => :item_type}
  	)
  end

  def remaining_ttl
    Time.now.utc.to_i - (self.created_at.utc.to_i + self.item.ttl) if self.item.ttl and self.item.ttl > 0
  end

  protected

  def drop_after_ttl
    Resque.enqueue_in(self.item.ttl.seconds, DropItemWorker, self.id) if self.gift and (not self.item.item_type.usable)
  end
end
