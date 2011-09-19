class AmfgateController < ApplicationController
  respond_to :html, :amf
  
#  public var sid:String;
#  public var character:CharacterDTO;  
  
  def authorize
    @character = Character.find_by_
    #@character.name = 'somewhatt 2323'
    render :amf => {:char => @character.to_amf(:except => [:updated_at, :created_at]), :someval => 123123}
  end

#  public var id:int;
#  public var uid:String;
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
  
  def getSessid
    1
  end
  
  
end
