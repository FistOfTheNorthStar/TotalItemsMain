class UpdateConcertsTableToItems < ActiveRecord::Migration[8.0]
  def change
    rename_table :concerts, :items
    rename_column :items, :total_tickets, :total_items
    rename_column :items, :available_tickets, :available_items
    change_column :items, :price, :decimal, precision: 15, scale: 6
  end
end
