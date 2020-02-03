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

ActiveRecord::Schema.define(version: 2020_02_03_124255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "kt_tips", force: :cascade do |t|
    t.string "topic"
    t.string "content"
    t.datetime "written_on"
    t.integer "likes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pays", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "network"
    t.string "account_name"
    t.string "account_number"
    t.string "bank_id"
    t.string "bank_branch_id"
    t.string "currency"
    t.string "value"
    t.string "location_url"
    t.text "response"
    t.text "result"
    t.integer "order_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stks", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "currency"
    t.string "value"
    t.string "location_url"
    t.text "response"
    t.text "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transfers", force: :cascade do |t|
    t.string "account_name"
    t.string "account_number"
    t.string "bank_ref_number"
    t.string "bank_branch_ref_no"
    t.string "target_destination"
    t.string "amount"
    t.string "location_url"
    t.text "response"
    t.text "result"
    t.boolean "order_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "webhook_subscriptions", force: :cascade do |t|
    t.string "secret"
    t.string "event"
    t.string "location_url"
    t.string "access_token"
    t.text "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
