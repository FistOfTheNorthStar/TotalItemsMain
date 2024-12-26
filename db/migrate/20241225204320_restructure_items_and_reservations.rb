class RestructureItemsAndReservations < ActiveRecord::Migration[8.0]
  def change
    # Rename reservations to orders
    rename_table :reservations, :orders
    add_column :orders, :type, :string
    add_column :orders, :order_status, :string
    rename_table :items, :trees
    remove_column :trees, :total_items
    remove_column :trees, :available_items
    remove_column :trees, :reservation_limit
    remove_column :trees, :sale_start_time
    add_column :trees, :currency, :string
    add_column :trees, :gps_longitude, :string
    add_column :trees, :gps_latitude, :string
    add_column :trees, :tree_state, :string
    rename_column :orders, :item_id, :tree_id
  end
end
