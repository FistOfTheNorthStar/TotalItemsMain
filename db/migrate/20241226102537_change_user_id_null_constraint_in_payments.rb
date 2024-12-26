class ChangeUserIdNullConstraintInPayments < ActiveRecord::Migration[8.0]
  def change
    change_column_null :payments, :user_id, false
  end
end
