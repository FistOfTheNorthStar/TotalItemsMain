class AddExpiresAtToQueuePositions < ActiveRecord::Migration[8.0]
  def change
    add_column :queue_positions, :expires_at, :datetime, null: false
  end
end
