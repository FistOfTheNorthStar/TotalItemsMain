class RenameQueuePositionsConcertIdToItemId < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :queue_positions, column: :concert_id
    remove_index :queue_positions, :concert_id

    rename_column :queue_positions, :concert_id, :item_id

    add_index :queue_positions, :item_id
    add_foreign_key :queue_positions, :items, column: :item_id
  end
end
