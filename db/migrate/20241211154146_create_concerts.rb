class CreateConcerts < ActiveRecord::Migration[8.0]
  def change
    create_table :concerts do |t|
      t.string :name
      t.text :description
      t.datetime :date
      t.integer :total_tickets
      t.integer :available_tickets
      t.decimal :price

      t.timestamps
    end
  end
end
