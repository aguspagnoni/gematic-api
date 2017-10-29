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

ActiveRecord::Schema.define(version: 20171029203404) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.integer  "privilege"
    t.string   "name"
    t.string   "email"
    t.string   "family_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "image"
    t.string   "password_digest"
  end

  create_table "billing_infos", force: :cascade do |t|
    t.string   "address"
    t.string   "cuit"
    t.string   "condition"
    t.string   "razon_social"
    t.integer  "company_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "province"
    t.string   "localidad"
    t.string   "phone"
    t.string   "zipcode"
    t.string   "other_info"
    t.index ["company_id"], name: "index_billing_infos_on_company_id", using: :btree
  end

  create_table "branch_offices", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "address"
    t.string   "zipcode"
    t.string   "geolocation"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "phone"
    t.index ["company_id"], name: "index_branch_offices_on_company_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_categories_on_category_id", using: :btree
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.integer "product_id",  null: false
    t.integer "category_id", null: false
    t.index ["category_id", "product_id"], name: "index_categories_products_on_category_id_and_product_id", using: :btree
  end

  create_table "claims", force: :cascade do |t|
    t.text     "description"
    t.integer  "order_id"
    t.integer  "user_id"
    t.integer  "admin_user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["admin_user_id"], name: "index_claims_on_admin_user_id", using: :btree
    t.index ["order_id"], name: "index_claims_on_order_id", using: :btree
    t.index ["user_id"], name: "index_claims_on_user_id", using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     default: 0
  end

  create_table "discounts", force: :cascade do |t|
    t.float    "cents",         default: 0.0
    t.integer  "product_id"
    t.integer  "price_list_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "fixed",         default: false
    t.float    "final_price"
    t.index ["price_list_id"], name: "index_discounts_on_price_list_id", using: :btree
    t.index ["product_id", "price_list_id"], name: "index_discounts_on_product_id_and_price_list_id", using: :btree
    t.index ["product_id"], name: "index_discounts_on_product_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "status",           default: 0
    t.date     "delivery_date"
    t.integer  "company_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "billing_info_id"
    t.integer  "branch_office_id"
    t.index ["billing_info_id"], name: "index_orders_on_billing_info_id", using: :btree
    t.index ["branch_office_id"], name: "index_orders_on_branch_office_id", using: :btree
    t.index ["company_id"], name: "index_orders_on_company_id", using: :btree
  end

  create_table "orders_products", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "order_id",   null: false
    t.integer "quantity",   null: false
    t.index ["product_id", "order_id"], name: "index_orders_products_on_product_id_and_order_id", using: :btree
  end

  create_table "price_lists", force: :cascade do |t|
    t.string   "name"
    t.date     "expires"
    t.date     "valid_since"
    t.integer  "company_id"
    t.integer  "admin_user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "authorized_at"
    t.integer  "authorizer_id"
    t.float    "general_discount", default: 0.0
    t.index ["admin_user_id"], name: "index_price_lists_on_admin_user_id", using: :btree
    t.index ["authorizer_id"], name: "index_price_lists_on_authorizer_id", using: :btree
    t.index ["company_id"], name: "index_price_lists_on_company_id", using: :btree
  end

  create_table "product_inputs", force: :cascade do |t|
    t.integer  "quantity",          default: 0
    t.float    "unit_price"
    t.string   "reference_number"
    t.string   "image"
    t.integer  "admin_user_id"
    t.integer  "product_id"
    t.integer  "seller_company_id"
    t.integer  "buyer_company_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["admin_user_id"], name: "index_product_inputs_on_admin_user_id", using: :btree
    t.index ["buyer_company_id"], name: "index_product_inputs_on_buyer_company_id", using: :btree
    t.index ["product_id"], name: "index_product_inputs_on_product_id", using: :btree
    t.index ["seller_company_id"], name: "index_product_inputs_on_seller_company_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.string   "code"
    t.float    "gross_price"
    t.float    "cost"
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "status",      default: 0
    t.integer  "stock"
    t.index ["code"], name: "index_products_on_code", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "family_name"
    t.string   "name"
    t.string   "phone_number"
    t.string   "cellphone"
    t.string   "job_position"
    t.integer  "company_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "image"
    t.string   "password_digest"
    t.integer  "status",          default: 0
    t.index ["company_id"], name: "index_users_on_company_id", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "price_lists", "admin_users", column: "authorizer_id"
  add_foreign_key "product_inputs", "billing_infos", column: "buyer_company_id"
  add_foreign_key "product_inputs", "billing_infos", column: "seller_company_id"
end
