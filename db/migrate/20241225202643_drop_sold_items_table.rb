class DropSoldItemsTable < ActiveRecord::Migration[8.0]
  def up
    drop_table :sold_items
  end

  def down
    create_table :sold_items do |t|
      t.bigint :reservation_id, null: false
      t.bigint :customer_id, null: false
      t.string :receipt
      t.string :ticket
      t.string :uuid, null: false
      t.timestamps

      t.index :customer_id
      t.index :reservation_id
      t.index :uuid, unique: true
    end
  end
end
