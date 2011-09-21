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
      :sex => @misc_params[1],
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

  def get_presents
    render :amf => load_presents
  end

  def get_gifts
    render :amf => load_gifts
  end

  def get_giftable_items
    render :amf => load_giftable_items
  end

  def make_a_gift
    item = Item.find @misc_params[0]
    target_char = Character.find @misc_params[1]
    return false if item.nil? or target_char.nil?
    render :amf => @character.make_a_gift(item, target_char)
  end

  protected

  def load_giftable_items
    items = []
    Item.find_giftable.each {|item| items << item.dto}
    return items
  end

  def load_gifts
    items = []
    @character.gift_items.each { |gift| items << gift.gift_dto }
    return items
  end

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
