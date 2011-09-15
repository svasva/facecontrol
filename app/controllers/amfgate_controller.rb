class AmfgateController < ApplicationController
  respond_to :html, :amf
  
#  public var sid:String;
#  public var character:CharacterDTO;  
  
  def autorize
    @character_id = self.get_character(params)
    @character = Character.find(@character_id)
    @sessid = self.getSessid
    respond_with(@character) do |format|
      format.amf { render :amf => @character.to_amf(:character => [:updated_at, :created_at]) }
    end
  end

#viewer_id
#public class UserDTO
# {
#  public var id:int;
#  public var uid:String;
#  public var name:String;
#  public var sex:int = 0;
#  //
#  public var level:int = 0;
#  public var rating:int = 0;
#  
#  /**  текущая слава */
#  public var glory:int = 0;
#  public var realGlory:int = 0;
#  
#  /**  текущий гламур */
#  public var glamour:int = 0;
#  
#  /** симпатия этого человека ко мне */
#  public var liking:int = 0;
#  
#  public function UserDTO()
#  {
#  }
# }
#-----------------------------------------------------------------
#public class CharacterDTO extends UserDTO
# {
#  public var gold:int = 0;
#  public var energy:int = 0;
#  public var drive:int = 0;
#  
#  public function CharacterDTO()
#  {
#   
#  }
# }

  def getCharacter(params)
    Character.new
  end
  
  def getSessid
    1
  end
  
  
end
