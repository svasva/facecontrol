class Place < ActiveRecord::Base
  has_many :actions, :as => :subject
  #has_one leave/enter/etc
end
