class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :concert, null: false, foreign_key: true
      t.string :status
      t.datetime :expires_at

      t.timestamps
    end
  end
end
