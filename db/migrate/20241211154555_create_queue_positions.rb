class CreateQueuePositions < ActiveRecord::Migration[8.0]
  def change
    create_table :queue_positions do |t|
      t.string :user_token
      t.references :concert, null: false, foreign_key: true
      t.integer :position
      t.string :status

      t.timestamps
    end
  end
end
