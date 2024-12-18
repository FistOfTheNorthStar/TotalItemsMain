class DropQueuePositions < ActiveRecord::Migration[8.0]
  def up
    drop_table :queue_positions
  end

  def down
    create_table :queue_positions do |t|
      t.string "user_token"
      t.bigint "item_id", null: false
      t.integer "position"
      t.string "status"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "reservation_id", null: false
      t.datetime "expires_at", null: false
      t.index [ "item_id" ], name: "index_queue_positions_on_item_id"
      t.index [ "reservation_id" ], name: "index_queue_positions_on_reservation_id"
    end
  end
end