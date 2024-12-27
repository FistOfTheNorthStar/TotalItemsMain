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

ActiveRecord::Schema[8.0].define(version: 2024_12_26_121819) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.integer "quantity", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "type", default: 0, null: false
    t.integer "order_status", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "subscription_id"
    t.datetime "order_completed_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_orders_on_status"
    t.index ["subscription_id"], name: "index_orders_on_subscription_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 6, default: "0.0", null: false
    t.string "currency", default: "EUR", null: false
    t.integer "provider", default: 0, null: false
    t.integer "payment_status", default: 0, null: false
    t.string "token"
    t.datetime "payment_confirmed_date"
    t.string "provider_confirmation_id"
    t.text "error"
    t.bigint "subscription_id"
    t.bigint "user_id", null: false
    t.bigint "order_id"
    t.decimal "tax", precision: 15, scale: 6, default: "0.0", null: false
    t.decimal "tax_percentage", precision: 5, scale: 6, default: "0.0", null: false
    t.boolean "tax_inclusive", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["payment_status"], name: "index_payments_on_payment_status"
    t.index ["provider"], name: "index_payments_on_provider"
    t.index ["subscription_id"], name: "index_payments_on_subscription_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "plant_a_tree_admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "address_1", default: "", null: false
    t.string "phone", default: "", null: false
    t.integer "role", default: 0, null: false
    t.string "first_name", default: "", null: false
    t.string "title", default: "", null: false
    t.string "important", default: "", null: false
    t.boolean "revoked", default: false
    t.string "last_name", default: "", null: false
    t.string "address_2", default: "", null: false
    t.string "city", default: "", null: false
    t.integer "country", default: 0, null: false
    t.integer "phone_prefix", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_plant_a_tree_admins_on_email", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.decimal "price", precision: 15, scale: 6, default: "0.0", null: false
    t.decimal "tax_percentage", precision: 5, scale: 2, default: "0.0", null: false
    t.boolean "tax_inclusive", default: true, null: false
    t.integer "type", default: 0, null: false
    t.integer "number_available", default: 1, null: false
    t.datetime "sales_start_date"
    t.datetime "sales_stop_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sales_start_date"], name: "index_products_on_sales_start_date"
    t.index ["sales_stop_date"], name: "index_products_on_sales_stop_date"
    t.index ["type"], name: "index_products_on_type"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "payment_status", default: 0, null: false
    t.integer "type", default: 0, null: false
    t.integer "renew_date", default: 0, null: false
    t.integer "number_of_trees", default: 0, null: false
    t.decimal "fee", precision: 15, scale: 6, default: "0.0", null: false
    t.string "currency", default: "EUR", null: false
    t.bigint "product_id", null: false
    t.decimal "tax", precision: 15, scale: 6, default: "0.0", null: false
    t.decimal "tax_percentage", precision: 5, scale: 6, default: "0.0", null: false
    t.boolean "tax_inclusive", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_status"], name: "index_subscriptions_on_payment_status"
    t.index ["product_id"], name: "index_subscriptions_on_product_id"
    t.index ["status"], name: "index_subscriptions_on_status"
    t.index ["type"], name: "index_subscriptions_on_type"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "trees", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 15, scale: 6, default: "0.0", null: false
    t.string "currency", default: "EUR", null: false
    t.string "gps_longitude"
    t.string "gps_latitude"
    t.string "new_user_email"
    t.string "new_user_sha256"
    t.integer "tree_state", default: 0, null: false
    t.bigint "user_id"
    t.bigint "product_id"
    t.decimal "tax", precision: 15, scale: 6, default: "0.0", null: false
    t.decimal "tax_percentage", precision: 5, scale: 6, default: "0.0", null: false
    t.boolean "tax_inclusive", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_trees_on_product_id"
    t.index ["user_id"], name: "index_trees_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "address_1", default: "", null: false
    t.string "phone", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "address_2", default: "", null: false
    t.string "city", default: "", null: false
    t.integer "country", default: 0, null: false
    t.integer "phone_prefix", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "orders", "subscriptions"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "payments", "subscriptions"
  add_foreign_key "payments", "users"
  add_foreign_key "subscriptions", "products"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "trees", "products"
  add_foreign_key "trees", "users"
end
