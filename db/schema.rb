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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140105205022) do

  create_table "coms", force: true do |t|
    t.string   "chamber"
    t.string   "committee_id"
    t.string   "name"
    t.string   "parent_committee_id"
    t.boolean  "subcommittee"
    t.integer  "rep_id"
    t.integer  "sen_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "del_id"
  end

  add_index "coms", ["del_id"], name: "index_coms_on_del_id"
  add_index "coms", ["rep_id"], name: "index_coms_on_rep_id"
  add_index "coms", ["sen_id"], name: "index_coms_on_sen_id"

  create_table "dels", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "name_suffix"
    t.string   "gender"
    t.string   "title"
    t.string   "bioguide_id"
    t.string   "birthday"
    t.string   "chamber"
    t.string   "contact_form"
    t.integer  "district"
    t.string   "facebook_id"
    t.string   "fax"
    t.boolean  "in_office"
    t.string   "nickname"
    t.string   "office"
    t.string   "party"
    t.string   "phone"
    t.string   "state"
    t.string   "state_name"
    t.string   "term_end"
    t.string   "term_start"
    t.string   "twitter_id"
    t.string   "website"
    t.string   "youtube_id"
    t.string   "state_rank"
    t.string   "senate_class"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dels", ["venue_id"], name: "index_dels_on_venue_id"

  create_table "reps", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "name_suffix"
    t.string   "gender"
    t.string   "title"
    t.string   "bioguide_id"
    t.string   "birthday"
    t.string   "chamber"
    t.string   "contact_form"
    t.integer  "district"
    t.string   "facebook_id"
    t.string   "fax"
    t.boolean  "in_office"
    t.string   "nickname"
    t.string   "office"
    t.string   "party"
    t.string   "phone"
    t.string   "state"
    t.string   "state_name"
    t.string   "term_end"
    t.string   "term_start"
    t.string   "twitter_id"
    t.string   "website"
    t.string   "youtube_id"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reps", ["venue_id"], name: "index_reps_on_venue_id"

  create_table "sens", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "name_suffix"
    t.string   "gender"
    t.string   "title"
    t.string   "bioguide_id"
    t.string   "birthday"
    t.string   "chamber"
    t.string   "contact_form"
    t.integer  "district"
    t.string   "facebook_id"
    t.string   "fax"
    t.boolean  "in_office"
    t.string   "nickname"
    t.string   "office"
    t.string   "party"
    t.string   "phone"
    t.string   "state"
    t.string   "state_name"
    t.string   "term_end"
    t.string   "term_start"
    t.string   "twitter_id"
    t.string   "website"
    t.string   "youtube_id"
    t.string   "state_rank"
    t.string   "senate_class"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sens", ["venue_id"], name: "index_sens_on_venue_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "venues", force: true do |t|
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "bookmark",       default: false
    t.string   "streetname"
    t.integer  "streetnumber"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.string   "residentname"
    t.text     "notes"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resident_first"
    t.string   "resident_last"
  end

  add_index "venues", ["user_id"], name: "index_venues_on_user_id"

  create_table "zooms", force: true do |t|
    t.integer  "level",      default: 6
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zooms", ["user_id"], name: "index_zooms_on_user_id"

end
