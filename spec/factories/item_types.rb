# encoding: utf-8

FactoryGirl.define do 
  factory :drinks_type, :class => ItemType do
    name "drinks"
    description "Коктейли"
    wearable false
    giftable true
    unique false
    own_limit 0
    exclusive false
  end

  factory :gifts_type, :class => ItemType do
    name "drinks"
    description "Подарки"
    wearable false
    giftable true
    unique false
    own_limit 0
    exclusive false
  end
    
  factory :clothes_type, :class => ItemType do
    name "clothes"
    description "Гламур"
    wearable true
    giftable false
    unique false
    own_limit 0
    exclusive false
  end
end

