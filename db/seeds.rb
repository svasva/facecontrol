# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ItemType.find_or_create_by_name :name => "drinks",
	:description => "Коктель",
	:wearable => false,
	:giftable => true,
	:unique => false,
	:own_limit => 0,
	:exclusive => false

ItemType.find_or_create_by_name :name => "gifts",
	:description => "Подарок",
	:wearable => false,
	:giftable => true,
	:unique => false,
	:own_limit => 0,
	:exclusive => false
	
ItemType.find_or_create_by_name :name => "clothes",
	:description => "Гламур",
	:wearable => true,
	:giftable => false,
	:unique => false,
	:own_limit => 0,
	:exclusive => false