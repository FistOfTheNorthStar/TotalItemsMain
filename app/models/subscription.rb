class Subscription < ApplicationRecord
  belongs_to :user
  has_many :orders
  has_many :payments

  validates :status, :payment_status, :type, :renew_date, :number_of_trees, presence: true
  validates :fee, :tax, :tax_percentage, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
  validates :tax_inclusive, inclusion: { in: [true, false] }

  enum :status, [ :active_monthly, :active_yearly, :paused, :cancelled ]
  enum :payment_status, [ :cycle_start, :pending, :paid, :failed, :refunded ]
  enum :type, [ :regular, :family, :company ]
end