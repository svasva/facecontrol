class Item < ActiveRecord::Base
  has_many :actions, :as => :subject
end
