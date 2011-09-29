# encoding: utf-8

FactoryGirl.define do 
  factory :drink_type, :class => ItemType do
    name "drink"
    description "Коктейли"
    wearable false
    giftable true
    own_limit 0
    exclusive false
  end

  factory :gifts_type, :class => ItemType do
    name "drinks"
    description "Подарки"
    wearable false
    giftable true
    own_limit 0
    exclusive false
  end
    
  factory :clothes_type, :class => ItemType do
    name "clothes"
    description "Гламур"
    wearable true
    giftable false
    own_limit 0
    exclusive false
  end
end

