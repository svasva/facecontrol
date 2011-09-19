# encoding: utf-8

FactoryGirl.define do 

  factory :enter, :class => Action do
  	name "Зайти"
  	need_target false
  	repeat false
    default_type "enter"
  end

  factory :stay, :class => Action do
    name "Тусить"
  	need_target false
  	repeat true
  	delay 60 #60 seconds
    default_type "stay"
  end

	factory :leave, :class => Action do
    name "Выйти"
  	need_target false
  	repeat false
    default_type "leave"
  end

  factory :enter_c, :class => Condition do
    name "Фейс контроль"
  end  

  factory :bo_enter_c, :parent => :enter_c do
    glory       1
    real_glory  2
    glamour     3
    energy      4
    #Default opertor
  end

  factory :bo_enter, :parent => :enter do
    conditions {|c| [Factory.create(:bo_enter_c)]}
  end

  factory :bo_stay, :parent => :stay do
    delta_energy -100
    delta_glory 200
    delta_drive 50
    delta_glamour 500
  end

  factory :blue_oyster, :class => Place do
    name "Бар 'Голубая устрица'"
    description  "всем известное место"
    picture_url "http://pic.ru"
    association :enter_action, :factory => :bo_enter
    association :stay_action, :factory => :bo_stay
    association :leave_action, :factory => :leave
  end
end

