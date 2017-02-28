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

ActiveRecord::Schema.define(version: 20170228223004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.integer  "privilege"
    t.string   "name"
    t.string   "email"
    t.string   "family_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "billing_infos", force: :cascade do |t|
    t.string   "address"
    t.string   "cuit"
    t.string   "condition"
    t.string   "razon_social"
    t.integer  "client_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["client_id"], name: "index_billing_infos_on_client_id", using: :btree
  end

  create_table "catgories", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_catgories_on_category_id", using: :btree
  end

  create_table "claims", force: :cascade do |t|
    t.text     "description"
    t.integer  "order_id"
    t.integer  "client_id"
    t.integer  "admin_user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["admin_user_id"], name: "index_claims_on_admin_user_id", using: :btree
    t.index ["client_id"], name: "index_claims_on_client_id", using: :btree
    t.index ["order_id"], name: "index_claims_on_order_id", using: :btree
  end

  create_table "clients", force: :cascade do |t|
    t.string   "address"
    t.string   "email"
    t.string   "family_name"
    t.string   "name"
    t.string   "phone_number"
    t.string   "cellphone"
    t.string   "job_position"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.integer  "cents"
    t.integer  "product_id"
    t.integer  "price_list_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["price_list_id"], name: "index_discounts_on_price_list_id", using: :btree
    t.index ["product_id", "price_list_id"], name: "index_discounts_on_product_id_and_price_list_id", using: :btree
    t.index ["product_id"], name: "index_discounts_on_product_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "state"
    t.date     "delivery_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "orders_products", id: false, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "order_id",   null: false
    t.index ["product_id", "order_id"], name: "index_orders_products_on_product_id_and_order_id", using: :btree
  end

  create_table "price_lists", force: :cascade do |t|
    t.string   "name"
    t.date     "expires"
    t.date     "valid_since"
    t.integer  "client_id"
    t.integer  "admin_user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["admin_user_id"], name: "index_price_lists_on_admin_user_id", using: :btree
    t.index ["client_id"], name: "index_price_lists_on_client_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.string   "code"
    t.integer  "gross_price"
    t.integer  "cost"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["code"], name: "index_products_on_code", unique: true, using: :btree
  end

end
