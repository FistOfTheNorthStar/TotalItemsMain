class ModifyTreesColumns < ActiveRecord::Migration[8.0]
  def change
    remove_column :trees, :date
    remove_column :trees, :valid_until

    add_reference :trees, :user, foreign_key: true
  end
end