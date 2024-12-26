class CreatePaymentsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 15, scale: 6, default: 0.0, null: false
      t.string :currency, default: 'EUR', null: false
      t.integer :provider, default: 0, null: false
      t.integer :payment_status, default: 0, null: false
      t.string :token
      t.datetime :payment_confirmed_date
      t.string :provider_confirmation_id
      t.text :error
      t.timestamps
      t.references :subscription, foreign_key: true
      t.references :user, foreign_key: true
      t.references :order, foreign_key: true
      t.index :payment_status
      t.index :provider
    end
  end
end
