class CreateInitialSchema < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 15, scale: 6, default: 0.0, null: false
      t.decimal :tax_percentage, precision: 5, scale: 2, default: 0.0, null: false
      t.boolean :tax_inclusive, default: true, null: false
      t.integer :type, default: 0, null: false
      t.integer :number_available, default: 1, null: false
      t.datetime :sales_start_date
      t.datetime :sales_stop_date
      t.timestamps
      t.index :type
      t.index :sales_start_date
      t.index :sales_stop_date
    end

    create_table :plant_a_tree_admins do |t|
      t.string :email, null: false
      t.string :address_1, default: "", null: false
      t.string :phone, default: "", null: false
      t.integer :role, default: 0, null: false
      t.string :first_name, default: "", null: false
      t.string :title, default: "", null: false
      t.string :important, default: "", null: false
      t.boolean :revoked, default: false
      t.string :last_name, default: "", null: false
      t.string :address_2, default: "", null: false
      t.string :city, default: "", null: false
      t.integer :country, default: 0, null: false
      t.integer :phone_prefix, default: 0, null: false
      t.timestamps
      t.index :email, name: "index_plant_a_tree_admins_on_email", unique: true
    end

    create_table :users do |t|
      t.string :email, null: false
      t.string :address_1, null: false, default: ''
      t.string :phone, null: false, default: ''
      t.string :first_name, null: false, default: ''
      t.string :last_name, null: false, default: ''
      t.string :address_2, null: false, default: ''
      t.string :city, null: false, default: ''
      t.integer :country, null: false, default: 0
      t.integer :phone_prefix, null: false, default: 0
      t.timestamps
      t.index :email
    end

    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.integer :payment_status, null: false, default: 0
      t.integer :type, null: false, default: 0
      t.integer :renew_date, null: false, default: 0
      t.integer :number_of_trees, null: false, default: 0
      t.decimal :fee, precision: 15, scale: 6, null: false, default: 0.0
      t.string :currency, null: false, default: 'EUR'
      t.references :product, null: false, foreign_key: true
      t.decimal :tax, precision: 15, scale: 6, null: false, default: 0.0
      t.decimal :tax_percentage, precision: 5, scale: 6, null: false, default: 0.0
      t.boolean :tax_inclusive, null: false, default: true
      t.timestamps
      t.index :payment_status
      t.index :status
      t.index :type
    end

    create_table :orders do |t|
      t.integer :quantity, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :type, null: false, default: 0
      t.integer :order_status, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :subscription, foreign_key: true
      t.datetime :order_completed_date
      t.timestamps
      t.index :status
    end

    create_table :payments do |t|
      t.decimal :amount, precision: 15, scale: 6, null: false, default: 0.0
      t.string :currency, null: false, default: 'EUR'
      t.integer :provider, null: false, default: 0
      t.integer :payment_status, null: false, default: 0
      t.string :token
      t.datetime :payment_confirmed_date
      t.string :provider_confirmation_id
      t.text :error
      t.references :subscription, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :order, foreign_key: true
      t.decimal :tax, precision: 15, scale: 6, null: false, default: 0.0
      t.decimal :tax_percentage, precision: 5, scale: 6, null: false, default: 0.0
      t.boolean :tax_inclusive, null: false, default: true
      t.timestamps
      t.index :payment_status
      t.index :provider
    end

    create_table :trees do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 15, scale: 6, null: false, default: 0.0
      t.string :currency, null: false, default: 'EUR'
      t.string :gps_longitude
      t.string :gps_latitude
      t.string :new_user_email
      t.string :new_user_sha256
      t.integer :tree_state, null: false, default: 0
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.decimal :tax, precision: 15, scale: 6, null: false, default: 0.0
      t.decimal :tax_percentage, precision: 5, scale: 6, null: false, default: 0.0
      t.boolean :tax_inclusive, null: false, default: true
      t.timestamps
    end
  end
end
