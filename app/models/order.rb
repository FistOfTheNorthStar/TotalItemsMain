class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :subscription, optional: true
  belongs_to :payment, optional: true

  validates :quantity, :order_status, :product_type, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  enum :order_status, [ :fulfilled, :refunded, :cancelled, :subscription, :payment ]

  enum :product_type, %w[01 02 03 04 05 014 boompje]
end
