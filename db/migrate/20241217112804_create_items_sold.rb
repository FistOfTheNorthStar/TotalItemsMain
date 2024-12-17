class CreateItemsSold < ActiveRecord::Migration[8.0]
  def change
    create_table :items_sold do |t|
      t.belongs_to :reservation, null: false, foreign_key: true
      t.belongs_to :customer, null: false, foreign_key: true
      t.string :receipt
      t.string :ticket
      t.timestamps
    end
  end
end