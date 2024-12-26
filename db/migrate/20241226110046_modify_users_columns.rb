class ModifyUsersColumns < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :address_1, from: nil, to: ''
    change_column_null :users, :address_1, false

    change_column_default :users, :address_2, from: nil, to: ''
    change_column_null :users, :address_2, false

    change_column_default :users, :city, from: nil, to: ''
    change_column_null :users, :city, false

    change_column_default :users, :first_name, from: nil, to: ''
    change_column_null :users, :first_name, false

    change_column_default :users, :last_name, from: nil, to: ''
    change_column_null :users, :last_name, false

    change_column_default :users, :phone, from: nil, to: ''
    change_column_null :users, :phone, false

    remove_column :users, :country
    add_column :users, :country, :integer, default: 0, null: false
    add_column :users, :phone_prefix, :integer, default: 0, null: false
  end
end