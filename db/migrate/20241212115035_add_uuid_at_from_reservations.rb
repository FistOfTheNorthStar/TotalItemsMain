class AddUUIDAtFromReservations < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :uuid, :string
  end
end
