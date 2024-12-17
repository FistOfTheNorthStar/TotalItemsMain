class AddSaleStartTimeToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :sale_start_time, :datetime
    add_index :items, :sale_start_time
  end
end
