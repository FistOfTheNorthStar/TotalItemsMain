class AddValidUntilToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :valid_until, :datetime
    add_index :items, :valid_until
  end
end
