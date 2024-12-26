class RenameCustomersToUsersAndAddFields < ActiveRecord::Migration[8.0]
  def change
    rename_table :customers, :users

    change_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :address_2
      t.string :city
      t.string :country
    end

    rename_column :users, :shipping_address, :address_1
  end
end