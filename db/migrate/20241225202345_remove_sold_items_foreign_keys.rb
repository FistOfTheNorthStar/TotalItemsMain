class RemoveSoldItemsForeignKeys < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :reservations, :items
    remove_foreign_key :sold_items, :reservations
    remove_foreign_key :sold_items, column: :customer_id
  end
end
