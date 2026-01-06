# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_01_06_032649) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "kt_tips", force: :cascade do |t|
    t.string "topic"
    t.string "content"
    t.datetime "written_on", precision: nil
    t.integer "likes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pay_recipients", force: :cascade do |t|
    t.string "recipient_type"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "network"
    t.string "account_name"
    t.string "account_number"
    t.string "bank_id"
    t.string "bank_branch_id"
    t.string "location_url"
    t.jsonb "response"
    t.jsonb "result"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.jsonb "metadata"
  end

  create_table "pays", force: :cascade do |t|
    t.string "destination"
    t.string "currency"
    t.string "value"
    t.string "location_url"
    t.jsonb "response"
    t.jsonb "result"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "settlements", force: :cascade do |t|
    t.string "settlement_type"
    t.string "account_name"
    t.string "account_number"
    t.string "bank_branch_ref"
    t.string "settlement_method"
    t.string "phone_number"
    t.string "network"
    t.string "location_url"
    t.jsonb "response"
    t.jsonb "result"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "msisdn"
  end

  create_table "stks", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "currency"
    t.string "value"
    t.string "location_url"
    t.jsonb "response"
    t.jsonb "result"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "transfers", force: :cascade do |t|
    t.string "destination_type"
    t.string "destination_reference"
    t.string "currency"
    t.string "value"
    t.string "location_url"
    t.jsonb "response"
    t.jsonb "result"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "webhook_subscriptions", force: :cascade do |t|
    t.string "secret"
    t.string "event"
    t.string "location_url"
    t.string "access_token"
    t.text "result"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end
end
