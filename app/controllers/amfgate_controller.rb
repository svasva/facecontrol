class AmfgateController < ApplicationController
  respond_to :amf
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
      :energy => GloryLevel.find_by_level(1).max_energy,
      :drive => 100,
      :money => 5,
      :real_glory => 1,
      :glory => 1
    }
    new_char = Character.create(char_params) unless char_params.nil?
    new_char.acquire_default_rumors
    render :amf => new_char.dto
  end

  # @param: Character.id
  def get_rumors
    render :amf => Character.find(@misc_params[0]).messages.rumors.map(&:dto)
  end

  # NON-ASYNC  
  def buy_clicks
    render :amf => @character.buy_clicks
  end

  # @param: Character.id
  def get_interviews
    render :amf => Character.find(@misc_params[0]).messages.questions.map(&:dto)
  end

  # @param: msg.content
  # @param: msg.target_id
  # @param: msg.need_answer
  # @param: msg.anonymous
  def post_message
    if @misc_params[3]
      render :amf => @character.post_message(
        @misc_params[2], # content
        @misc_params[1], # target_id
        @misc_params[0], # need_answer
        @misc_params[3]  # anonymous
      ).dto
    else
      render :amf => @character.post_message(
        @misc_params[2],
        @misc_params[1],
        @misc_params[0]
      ).dto
    end
  end

  # @param: reply.reply_to
  # @param: reply.content
  def post_reply
    render :amf => @character.post_reply(@misc_params[1], @misc_params[0]).dto
  end

  def get_rumors_to_vote
    render :amf => (load_rumors_to_vote << GameAction.vote.last.dto)
  end

  # @param: Message.id (+)
  # @param: Message.id (-)
  def vote_for_rumors
    #TODO investigate condition checks
    @character.vote_for_message @misc_params[0], true
    @character.vote_for_message @misc_params[1], false
    @character.do_action GameAction.vote.first
    render :amf => load_rumors_to_vote
  end

  # NON-ASYNC
  # @param: ExchangeRate.id
  def request_funds
    return false unless (er = ExchangeRate.find(@misc_params[0]))
    render :amf => @character.withraw_vk(er, FCconfig.app_id, FCconfig.app_secret)
  end

  def get_chars_to_vote
    render :amf => (load_chars_to_vote << GameAction.vote.last.dto)
  end

  # @param: Character.id (+)
  # @param: Character.id (-)
  def vote_for_chars
    #TODO investigate condition checks
    @character.vote_for_char @misc_params[0], true
    @character.vote_for_char @misc_params[1], false
    @character.do_action GameAction.vote.first
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
  def drink
    render :amf => @character.do_action(CharacterItem.find(@misc_params[0]).item.use_action)
  end

  # @param: Item.id
  def take_off
    render :amf => @character.take_off(@character.items.find_by_item_id(@misc_params[0])).dto
  end

  # @param: Item.id
  # @param: for_gold:boolean
  def buy_item
    item = Item.find @misc_params[0]
    return false if item.nil?
    render :amf => @character.buy_item(item, @misc_params[1])
  end

  # @param: Item.id
  # @param: Action.target_character_id
  # @param: for_gold:boolean
  def make_a_gift
    item = Item.find @misc_params[0]
    target_char = Character.find @misc_params[1]
    return false if item.nil? or target_char.nil?
    render :amf => (ret = @character.make_a_gift(item, target_char, @misc_params[2])) ? ret.dto : false
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
    render :amf => Place.find(@misc_params[0]).club_dto(@character)
  end

  def get_action_groups
    render :amf => ActionGroup.last.dto(@character) if ActionGroup.count > 0
  end

  # @param: Character.id
  def ignore_char
    render :amf => @character.ignore_char(@misc_params[0])
  end

  # @param: Message.id
  def ignore_msg
    render :amf => @character.ignore_msg(@misc_params[0])
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

    first, second = Message.rumors.order('RAND()').where{rating >= 0}.limit(2)
    return [first.dto, second.dto, @character.clicks_remaining]
  end

  def load_chars_to_vote
    first, second = Character.order('RAND()').limit(2)
    return [first.dto, second.dto, @character.clicks_remaining]
  end

  # @param: array
  # @param[0][0]: @flash_vars
  # @param[0][1..-1]: @misc_params
  def amf_init
    @flash_vars = params[0][0]
    @misc_params = []
    params[0].each {|p| @misc_params << p unless p == @flash_vars }

    raise "unauthorized! : #{FCconfig.app_id}, #{FCconfig.app_secret}" unless auth_vk? @flash_vars['viewer_id'], @flash_vars['auth_key']
    @character = Character.find(:first, :conditions => {:social_id => @flash_vars['viewer_id']})
    @character.restore_energy if @character
  end
  
  # @param: Character.social_id
  # @param: @flash_vars['auth_key']
  def auth_vk?(social_id, session_key)
    auth_key = Digest::MD5.hexdigest "#{FCconfig.app_id}_#{social_id}_#{FCconfig.app_secret}"
    return auth_key == session_key
  end
end
