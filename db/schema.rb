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

ActiveRecord::Schema.define(version: 20180409210742) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "barcode"
    t.string "brand"
    t.float "quantity"
    t.string "unit_measure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "supermarket_addresses", force: :cascade do |t|
    t.decimal "lat"
    t.decimal "lng"
    t.string "street_number"
    t.string "street_name"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.string "place_id"
    t.bigint "supermarket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supermarket_id"], name: "index_supermarket_addresses_on_supermarket_id"
  end

  create_table "supermarket_product_prices", force: :cascade do |t|
    t.bigint "supermarket_product_id"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supermarket_product_id"], name: "index_supermarket_product_prices_on_supermarket_product_id"
  end

  create_table "supermarket_products", force: :cascade do |t|
    t.bigint "supermarket_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_supermarket_products_on_product_id"
    t.index ["supermarket_id"], name: "index_supermarket_products_on_supermarket_id"
  end

  create_table "supermarkets", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "supermarket_addresses", "supermarkets"
  add_foreign_key "supermarket_product_prices", "supermarket_products"
  add_foreign_key "supermarket_products", "products"
  add_foreign_key "supermarket_products", "supermarkets"
end
