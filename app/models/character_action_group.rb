class CharacterActionGroup < ActiveRecord::Base
  belongs_to :action_group
  belongs_to :character
end
