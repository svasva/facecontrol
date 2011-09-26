class ItemType < ActiveRecord::Base
  has_many :items
  include Models::ItemType::CsvExchange

end
