# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110913150512) do

  create_table "actions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "delay"
    t.integer  "parent_id"
    t.boolean  "has_children"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "repeat"
    t.integer  "delta_energy"
    t.integer  "delta_glory"
    t.integer  "delta_drive"
    t.integer  "delta_glamour"
    t.integer  "delta_real_glory"
    t.integer  "delta_money"
  end

  create_table "actions_conditions", :id => false, :force => true do |t|
    t.integer "action_id"
    t.integer "condition_id"
  end

  add_index "actions_conditions", ["action_id", "condition_id"], :name => "index_actions_conditions_on_action_id_and_condition_id"

  create_table "character_actions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "action_id"
    t.string   "status"
    t.datetime "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "character_actions", ["status"], :name => "index_character_actions_on_status"
  add_index "character_actions", ["user_id", "action_id"], :name => "index_character_actions_on_user_id_and_action_id"

  create_table "characters", :force => true do |t|
    t.string   "name"
    t.integer  "energy"
    t.integer  "drive"
    t.integer  "glory"
    t.integer  "real_glory"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conditions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "actions_id"
    t.integer  "energy"
    t.integer  "drive"
    t.integer  "glory"
    t.integer  "real_glory"
    t.integer  "glamour"
    t.integer  "money"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conditions", ["actions_id"], :name => "index_conditions_on_actions_id"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "glamour"
    t.integer  "conditions_id"
    t.string   "picture_url"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["conditions_id"], :name => "index_items_on_conditions_id"

  create_table "places", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "picture_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places_conditions", :id => false, :force => true do |t|
    t.integer "place_id"
    t.integer "condition_id"
  end

  add_index "places_conditions", ["place_id", "condition_id"], :name => "index_places_conditions_on_place_id_and_condition_id"

end
