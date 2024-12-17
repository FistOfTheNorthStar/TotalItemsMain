class CreateCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :customers do |t|
      t.string :email, null: false
      t.string :shipping_address
      t.string :phone

      t.timestamps

      t.index :email
    end
  end
end
