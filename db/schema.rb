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

ActiveRecord::Schema.define(version: 20130728184950) do

  create_table "product_prices", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stocking_distributor"
    t.integer  "non_stocking_distributor"
    t.integer  "managed_service_provider"
    t.integer  "installer_partner"
    t.integer  "list"
    t.integer  "product_id"
  end

  create_table "products", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "discontinued_on"
    t.string   "name"
    t.string   "uom"
    t.string   "code"
    t.integer  "part_number"
    t.text     "description"
    t.integer  "group_id"
    t.integer  "category_id"
    t.integer  "family_id"
  end

end
