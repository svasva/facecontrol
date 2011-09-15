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

ActiveRecord::Schema.define(:version => 20110915123820) do

  create_table "action_groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actions", :force => true do |t|
    t.string   "name",               :default => ""
    t.text     "description"
    t.integer  "delay",              :default => 0
    t.integer  "parent_id",          :default => 0
    t.boolean  "has_children",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "repeat",             :default => false
    t.integer  "delta_energy",       :default => 0
    t.integer  "delta_glory",        :default => 0
    t.integer  "delta_drive",        :default => 0
    t.integer  "delta_glamour",      :default => 0
    t.integer  "delta_real_glory",   :default => 0
    t.integer  "delta_money",        :default => 0
    t.integer  "contest_rating",     :default => 0
    t.integer  "action_group_id"
    t.integer  "ttl"
    t.integer  "disabler_action_id"
  end

  add_index "actions", ["action_group_id"], :name => "index_actions_on_action_group_id"

  create_table "actions_conditions", :id => false, :force => true do |t|
    t.integer "action_id"
    t.integer "condition_id"
  end

  add_index "actions_conditions", ["action_id", "condition_id"], :name => "index_actions_conditions_on_action_id_and_condition_id"

  create_table "admins", :force => true do |t|
    t.string   "email",                              :default => "", :null => false
    t.string   "encrypted_password",  :limit => 128, :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                    :default => 0
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "character_action_groups", :force => true do |t|
    t.integer  "action_group_id"
    t.integer  "character_id"
    t.integer  "action_group_rating", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "character_action_groups", ["action_group_id", "character_id"], :name => "cag_index"

  create_table "character_actions", :force => true do |t|
    t.integer  "character_id"
    t.integer  "action_id"
    t.string   "status",              :default => "pending"
    t.datetime "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "target_character_id"
    t.datetime "stop_time"
    t.integer  "repeat_count",        :default => 0
    t.integer  "repeat_index"
  end

  add_index "character_actions", ["character_id", "action_id"], :name => "index_character_actions_on_character_id_and_action_id"
  add_index "character_actions", ["status"], :name => "index_character_actions_on_status"

  create_table "characters", :force => true do |t|
    t.string   "name",       :default => ""
    t.integer  "energy",     :default => 0
    t.integer  "drive",      :default => 0
    t.integer  "glory",      :default => 0
    t.integer  "glamour",    :default => 0
    t.integer  "real_glory", :default => 0
    t.integer  "money",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sex"
    t.integer  "level"
  end

  create_table "conditions", :force => true do |t|
    t.string   "name",        :default => ""
    t.string   "description", :default => ""
    t.integer  "actions_id"
    t.integer  "energy"
    t.integer  "drive"
    t.integer  "glory"
    t.integer  "real_glory"
    t.integer  "glamour"
    t.integer  "money"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "operator",    :default => ">="
  end

  add_index "conditions", ["actions_id"], :name => "index_conditions_on_actions_id"

  create_table "items", :force => true do |t|
    t.string   "name",          :default => ""
    t.text     "description"
    t.integer  "glamour",       :default => 0
    t.integer  "conditions_id"
    t.string   "picture_url",   :default => ""
    t.integer  "price",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["conditions_id"], :name => "index_items_on_conditions_id"

  create_table "places", :force => true do |t|
    t.string   "name",        :default => ""
    t.string   "description", :default => ""
    t.string   "picture_url", :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places_conditions", :id => false, :force => true do |t|
    t.integer "place_id"
    t.integer "condition_id"
  end

  add_index "places_conditions", ["place_id", "condition_id"], :name => "index_places_conditions_on_place_id_and_condition_id"

end
