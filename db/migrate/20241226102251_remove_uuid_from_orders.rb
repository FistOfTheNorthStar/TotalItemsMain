class RemoveUuidFromOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :uuid, :string
  end
end
