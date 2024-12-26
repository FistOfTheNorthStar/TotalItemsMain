class AddTaxFieldsToPriceTables < ActiveRecord::Migration[8.0]
  def change
    add_column :trees, :tax, :decimal, precision: 15, scale: 6, default: 0.0, null: false
    add_column :trees, :tax_percentage, :decimal, precision: 5, scale: 6, default: 0.0, null: false
    add_column :trees, :tax_inclusive, :boolean, default: true, null: false

    add_column :subscriptions, :tax, :decimal, precision: 15, scale: 6, default: 0.0, null: false
    add_column :subscriptions, :tax_percentage, :decimal, precision: 5, scale: 6, default: 0.0, null: false
    add_column :subscriptions, :tax_inclusive, :boolean, default: true, null: false

    add_column :payments, :tax, :decimal, precision: 15, scale: 6, default: 0.0, null: false
    add_column :payments, :tax_percentage, :decimal, precision: 5, scale: 6, default: 0.0, null: false
    add_column :payments, :tax_inclusive, :boolean, default: true, null: false
  end
end
