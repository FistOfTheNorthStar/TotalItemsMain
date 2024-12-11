class AddQuantityToReservations < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :quantity, :integer, null: false
  end
end
