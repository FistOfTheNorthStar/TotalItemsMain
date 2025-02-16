class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :subscription, optional: true

  validates :quantity, :order_status, :product_type, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  enum :order_status, [ :fulfilled, :refunded, :cancelled, :subscription, :payment, :payment_fulfilled, :finished ]

  enum :product_type, { "01": 0, "02": 1, "03": 2, "04": 3, "05": 4, "014": 5, "boompje": 6, "na": 7 }
  enum :tree_type, [ :no_tree, :yemani, :mango_tree ]
end
