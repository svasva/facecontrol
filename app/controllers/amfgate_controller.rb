class AmfgateController < ApplicationController
  respond_to :amf, :html
  before_filter :amf_init

  @character = nil

  # @param: Character
  def authorize
    unless @character.nil?
      @character.login_hook
      render :amf => @character.dto
    else
      render :amf => nil
    end
  end

  # @param: Character.name
  # @param: Character.male
  # @param: Character.social_id
  def register
    char_params = {
      :name => @misc_params[0],
      :male => @misc_params[1],
      :social_id => @flash_vars['viewer_id'],
      :energy => GloryLevel.where(:level => 1).first.max_energy,
      :money => 1,
      :real_glory => 1
    }
    render :amf => Character.create(char_params).dto unless char_params.nil?
  end

  # @param: Character.id
  def get_rumors
    render :amf => Character.find(@misc_params[0]).messages.rumors.map(&:dto)
  end
  
  # @param: Character.id
  def get_interviews
    render :amf => Character.find(@misc_params[0]).messages.questions.map(&:dto)
  end

  # @param: msg.content
  # @param: msg.target_id
  # @param: msg.need_answer
  def post_message
    render :amf => @character.post_message(@misc_params[2], @misc_params[1], @misc_params[0]).dto
  end

  # @param: reply.reply_to
  # @param: reply.content
  def post_reply
    render :amf => @character.post_reply(@misc_params[1], @misc_params[0]).dto
  end

  def get_rumors_to_vote
    render :amf => load_rumors_to_vote
  end

  # @param: Message.id (+)
  # @param: Message.id (-)
  def vote_for_rumors
    #TODO investigate condition checks
    @character.vote_for_message @misc_params[0], true
    @character.vote_for_message @misc_params[1], false
    @character.do_action Action.vote
    render :amf => load_rumors_to_vote
  end

  def get_chars_to_vote
    render :amf => load_chars_to_vote
  end

  # @param: Character.id (+)
  # @param: Character.id (-)
  def vote_for_chars
    #TODO investigate condition checks
    @character.vote_for_char @misc_params[0], true
    @character.vote_for_char @misc_params[1], false
    @character.do_action Action.vote.first
    render :amf => load_chars_to_vote
  end

  # @param: Message.id
  def delete_message
    render :amf => Message.find(@misc_params[0]).destroy.dto
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

  # @param: CharacterItem.id
  def put_on
    render :amf => @character.put_on(CharacterItem.find(@misc_params[0])).dto
  end

  # @param: CharacterItem.id
  def take_off
    render :amf => @character.take_off(CharacterItem.find(@misc_params[0])).dto
  end

  # @param: Item.id
  def buy_item
    item = Item.find @misc_params[0]
    return false if item.nil?
    render :amf => @character.buy_item(item)
  end

  # @param: Item.id
  # @param: Action.target_character_id
  def make_a_gift
    item = Item.find @misc_params[0]
    target_char = Character.find @misc_params[1]
    return false if item.nil? or target_char.nil?
    render :amf => @character.make_a_gift(item, target_char).dto
  end

  def get_my_items
    render :amf => @character.character_items.clothes.map(&:dto)
  end

  # @param: Place.id
  def enter_place
    club = @character.enter_place(Place.find(@misc_params[0]))
    render :amf => club ? club.club_dto(@character) : false
  end

  def leave_place
    render :amf => @character.leave_place.dto
  end

  # @param: Place.id
  def get_club_info
    render :amf => Place.find(@misc_params[0]).club_dto
  end

  def get_action_groups
    render :amf => ActionGroup.last.dto(@character) if ActionGroup.count > 0
  end

  # @param: ActionGroup.id
  def enter_contest
    render :amf => @character.enter_contest(@misc_params[0]).dto
  end

  # @param: array of Character.id
  def get_init_amf
    render :amf => InitAmfDTO.new(@character, @misc_params[0])
  end

  protected

  def load_rumors_to_vote
    return false if Message.rumors.where{rating >= 0}.count < 2
    clicks_remaining = 100 - @character.character_actions.votes.count

    first, second = Message.rumors.order('RAND()').where{rating >= 0}.limit(2)
    return [first.dto, second.dto, clicks_remaining]
  end

  def load_chars_to_vote
    clicks_remaining = 100 - @character.character_actions.votes.count

    first, second = Character.order('RAND()').limit(2)
    return [first.dto, second.dto, clicks_remaining]
  end

  # @param: array
  # @param[0][0]: @flash_vars
  # @param[0][1..-1]: @misc_params
  def amf_init
    @flash_vars = params[0][0]
    @misc_params = []
    params[0].each {|p| @misc_params << p unless p == @flash_vars }

    raise 'unauthorized!' unless auth_vk? @flash_vars['viewer_id'], @flash_vars['auth_key']
    @character = Character.find(:first, :conditions => {:social_id => @flash_vars['viewer_id']})
    @character.restore_energy if @character
  end
  
  # @param: Character.social_id
  # @param: @flash_vars['auth_key']
  def auth_vk?(social_id, session_key)
    app_id = '2452518'
    app_secret = 'c3j9y9BmHPcNo7JmkvRL'
    auth_key = Digest::MD5.hexdigest "#{app_id}_#{social_id}_#{app_secret}"
    return auth_key == session_key
  end
end
