class ModifyOrdersTable < ActiveRecord::Migration[8.0]
  def change
    remove_index :orders, :tree_id
    remove_column :orders, :tree_id

    change_column :orders, :quantity, :integer, null: false, default: 0

    remove_column :orders, :type
    add_column :orders, :type, :integer, null: false, default: 0

    remove_column :orders, :order_status
    add_column :orders, :order_status, :integer, null: false, default: 0

    add_reference :orders, :user, null: false, foreign_key: true
    add_reference :orders, :subscription, foreign_key: true

    add_column :orders, :order_completed_date, :datetime
  end
end