class ModifyTreesTable < ActiveRecord::Migration[8.0]
  def change
    add_column :trees, :new_user_email, :string
    add_column :trees, :new_user_sha256, :string

    remove_column :trees, :tree_state
    add_column :trees, :tree_state, :integer, default: 0, null: false

    change_column :trees, :price, :decimal, precision: 15, scale: 6, default: 0.0, null: false
    change_column :trees, :currency, :string, default: 'EUR', null: false
  end
end
