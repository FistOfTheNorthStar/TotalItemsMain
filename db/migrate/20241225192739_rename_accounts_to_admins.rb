class RenameAccountsToAdmins < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :customers, :accounts
    remove_foreign_key :items, :accounts

    remove_index :customers, :account_id
    remove_index :items, :account_id

    remove_column :customers, :account_id
    remove_column :items, :account_id

    rename_table :accounts, :admins
  end
end
