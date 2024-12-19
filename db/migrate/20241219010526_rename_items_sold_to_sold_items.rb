class RenameItemsSoldToSoldItems < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :items_sold, :customers
    remove_foreign_key :items_sold, :reservations

    rename_table :items_sold, :sold_items

    add_foreign_key :sold_items, :customers
    add_foreign_key :sold_items, :reservations
  end
end
