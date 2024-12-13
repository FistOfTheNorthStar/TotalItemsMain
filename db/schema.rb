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

ActiveRecord::Schema[8.0].define(version: 2024_12_12_165217) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "concerts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "date"
    t.integer "total_tickets"
    t.integer "available_tickets"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "queue_positions", force: :cascade do |t|
    t.string "user_token"
    t.bigint "concert_id", null: false
    t.integer "position"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "reservation_id", null: false
    t.datetime "expires_at", null: false
    t.index ["concert_id"], name: "index_queue_positions_on_concert_id"
    t.index ["reservation_id"], name: "index_queue_positions_on_reservation_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "concert_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", null: false
    t.datetime "expires_at"
    t.string "uuid"
    t.index ["concert_id"], name: "index_reservations_on_concert_id"
  end

  add_foreign_key "queue_positions", "concerts"
  add_foreign_key "queue_positions", "reservations"
  add_foreign_key "reservations", "concerts"
end
