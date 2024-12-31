class Order < ApplicationRecord
  belongs_to :user
  belongs_to :subscription, optional: true
  has_many :payments

  validates :quantity, :status, :type, :order_status, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  enum :status, [ :pending, :confirmed, :cancelled ]
  enum :type, [ :one_time, :subscription ]
  enum :order_status, [ :created, :processing, :completed, :failed ]
end
