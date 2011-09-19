class AmfgateController < ApplicationController
  respond_to :html, :amf
  before_filter :amf_init

  @character = nil
  @auth = false
  
#  public var sid:String;
#  public var character:CharacterDTO;  

  def authorize
    char = @character.amf unless @character.nil?
    render_amf
  end

  def register
    @character = Character.create @char_params unless @char_params.nil?
    render_amf
  end

#  public var id:int;
#  public var social_id:String;
#  public var name:String;
#  public var sex:int = 0;
#  public var level:int = 0;
#  public var rating:int = 0;
#  public var glory:int = 0;
#  public var real_glory:int = 0;
#  public var glamour:int = 0;
#  public var money:int = 0;
#  public var energy:int = 0;
#  public var drive:int = 0;
  
  protected

  def amf_init
    @flash_vars = params[0][0]
    @char_params = {
      :name => params[0][1],
      :sex => params[0][2]
    }
    @auth = auth_vk? @flashVars['viewer_id'], @flashVars['auth_key']
    @character = Character.find(:first, :conditions => {:social_id => flashVars['viewer_id']})
  end
  
  def auth_vk?(social_id, session_key)
    app_id = '2452518'
    app_secret = 'c3j9y9BmHPcNo7JmkvRL'
    auth_key = Digest::MD5.hexdigest "#{app_id}_#{social_id}_#{app_secret}"
    return auth_key == session_key
  end

  def render_amf
    render :amf => {
      :auth => @auth,
      :char => @character
    }
  end
end
