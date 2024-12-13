class AddReservationToQueuePositions < ActiveRecord::Migration[8.0]
  def change
    add_reference :queue_positions, :reservation, null: false, foreign_key: true
  end
end
