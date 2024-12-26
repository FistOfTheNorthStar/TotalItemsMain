class CreateSubscriptionsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.bigint :user_id, null: false
      t.integer :status, default: 0, null: false
      t.integer :payment_status, default: 0, null: false
      t.integer :type, default: 0, null: false
      t.integer :renew_date, default: 0, null: false
      t.integer :number_of_trees, default: 0, null: false
      t.decimal :fee, precision: 15, scale: 6, default: 0.0, null: false
      t.string :currency, default: 'EUR', null: false

      t.timestamps

      t.index :user_id
      t.index :status
      t.index :payment_status
      t.index :type
    end

    add_foreign_key :subscriptions, :users
  end
end
