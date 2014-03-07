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

ActiveRecord::Schema.define(version: 20140307025641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "bet_amount",  null: false
    t.integer  "win_amount",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "left_reel"
    t.integer  "middle_reel"
    t.integer  "right_reel"
  end

  add_index "games", ["user_id"], name: "index_games_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "key",                                   null: false
    t.string   "deposit_address",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",            default: "Shibe", null: false
    t.string   "ip_address"
    t.integer  "approximate_balance", default: 0
  end

  add_index "users", ["key"], name: "index_users_on_key", using: :btree

  create_table "withdrawals", force: true do |t|
    t.integer  "user_id",            null: false
    t.integer  "amount",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "withdrawal_address", null: false
  end

  add_index "withdrawals", ["user_id"], name: "index_withdrawals_on_user_id", using: :btree

end
