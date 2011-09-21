class CharacterItem < ActiveRecord::Base
  belongs_to :character
  belongs_to :source_character, :class_name => 'Character'
  belongs_to :item
  delegate :use_action, :to => :item


  def glamour
    self.item.glamour - (self.wear * self.item.wear_factor)
  end

  def gift_dto
  	GiftDTO.new self
  end

  def wear_limit
  	self.item.item_type.wear_limit
  end

  def unique?
  	self.item.item_type.unique
  end

  def wearable?
  	self.item.item_type.wearable
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
end
