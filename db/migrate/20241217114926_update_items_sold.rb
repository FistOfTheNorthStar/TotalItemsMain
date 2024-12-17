class UpdateItemsSold < ActiveRecord::Migration[8.0]
  def change
    change_table :items_sold do |t|
      t.string :uuid, null: false
      t.index :uuid, unique: true
    end
  end
end
