class AddReservationLimitToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :reservation_limit, :integer
  end
end
