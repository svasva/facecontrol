# encoding: utf-8

FactoryGirl.define do 
  factory :drink_type, :class => ItemType do
    name "drink"
    description "Коктель"
    wearable false
    giftable true
    unique false
    own_limit 0
    exclusive false
  end
end

