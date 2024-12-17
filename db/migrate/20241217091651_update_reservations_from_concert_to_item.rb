class UpdateReservationsFromConcertToItem < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :reservations, column: :concert_id
    remove_index :reservations, :concert_id

    rename_column :reservations, :concert_id, :item_id

    add_index :reservations, :item_id
    add_foreign_key :reservations, :items, column: :item_id
  end
end
