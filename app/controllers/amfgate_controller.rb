class AmfgateController < ApplicationController
  respond_to :amf
  before_filter :amf_init

  @character = nil
  @auth = false
  @amf = nil

#  public var sid:String;
#  public var character:CharacterDTO;  

  def authorize
    @amf = @character.amf unless @character.nil?
    render_amf
  end

  def register
    char_params = {
      :name => @misc_params[0],
      :sex => @misc_params[1],
      :social_id => @flash_vars['viewer_id']
    }
    @amf = Character.create(char_params).amf unless @char_params.nil?
    render_amf
  end

  def get_rumors(offset = 0, limit = 50)
    @amf = []
    limit.times.do
      @amf << Message.new(
        :text => "трололо #{rand(99999)}",
        :source => Character.first,
        :target => Character.last
      ).amf
    end
    render_amf
  end
  
  protected

  def amf_init
    @flash_vars = params[0][0]
    @misc_params = []
    params[0].each {|p| @misc_params << p unless p == @flash_vars }

    @auth = auth_vk? @flash_vars['viewer_id'], @flash_vars['auth_key']
    @character = Character.find(:first, :conditions => {:social_id => @flash_vars['viewer_id']})
  end
  
  def auth_vk?(social_id, session_key)
    app_id = '2452518'
    app_secret = 'c3j9y9BmHPcNo7JmkvRL'
    auth_key = Digest::MD5.hexdigest "#{app_id}_#{social_id}_#{app_secret}"
    return auth_key == session_key
  end

  def render_amf
    render :amf => @amf
  end
end
