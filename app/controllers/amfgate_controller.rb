class AmfgateController < ApplicationController
  respond_to :amf, :html
  before_filter :amf_init

  @character = nil

  def authorize
    unless @character.nil?
      render :amf => @character.dto
    else
      render :amf => nil
    end
  end

  def register
    char_params = {
      :name => @misc_params[0],
      :male => @misc_params[1],
      :social_id => @flash_vars['viewer_id']
    }
    render :amf => Character.create(char_params).dto unless char_params.nil?
  end

  def get_rumors
    render :amf => load_rumors
  end
  
  def get_interviews
    render :amf => load_rumors
  end

  def get_gifts
    render :amf => @character.gift_items.map(&:gift_dto)
  end

  def get_giftable_items
    render :amf => Item.giftable.map(&:dto)
  end

  def get_usable_items
    render :amf => Item.usable.map(&:dto)
  end

  def get_wearable_items
    render :amf => Item.wearable.map(&:dto)
  end

  def get_places
    render :amf => (Place.all.map {|p| PlaceDTO.new(p, @character)})
  end

  def put_on
    render :amf => @character.put_on(CharacterItem.find(@misc_params[0])).dto
  end

  def take_off
    render :amf => @character.take_off(CharacterItem.find(@misc_params[0])).dto
  end

  def buy_item
    item = Item.find @misc_params[0]
    return false if item.nil?
    render :amf => @character.buy_item(item).action.subject.dto
  end

  def make_a_gift
    item = Item.find @misc_params[0]
    target_char = Character.find @misc_params[1]
    return false if item.nil? or target_char.nil?
    render :amf => @character.make_a_gift(item, target_char).gift_dto
  end

  def get_my_items
    render :amf => @character.character_items.joins({:item => :item_type}).where(
      {:items => {:item_types => {:wearable => true} }}
    ).map(&:dto)
  end

  def enter_place
    render :amf => @character.enter_place(Place.find(@misc_params[0])).club_dto(@character)
  end

  def leave_place
    render :amf => @character.leave_place
  end

  protected

  def load_rumors(offset = 0, limit = 50)
    msgs = []
    limit.times do
      msgs << Message.new(
        :content => "trololo #{rand(99999)}",
        :source => Character.first,
        :target => Character.last
      ).dto
    end
    return msgs
  end

  def amf_init
    @flash_vars = params[0][0]
    @misc_params = []
    params[0].each {|p| @misc_params << p unless p == @flash_vars }

    raise 'unauthorized!' unless auth_vk? @flash_vars['viewer_id'], @flash_vars['auth_key']
    @character = Character.find(:first, :conditions => {:social_id => @flash_vars['viewer_id']})
  end
  
  def auth_vk?(social_id, session_key)
    app_id = '2452518'
    app_secret = 'c3j9y9BmHPcNo7JmkvRL'
    auth_key = Digest::MD5.hexdigest "#{app_id}_#{social_id}_#{app_secret}"
    return auth_key == session_key
  end
end
