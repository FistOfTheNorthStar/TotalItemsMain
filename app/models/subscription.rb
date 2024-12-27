class Subscription < ApplicationRecord
  belongs_to :user
  has_many :orders
  has_many :payments

  validates :status, :payment_status, :type, :renew_date, :number_of_trees, presence: true
  validates :fee, :tax, :tax_percentage, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
  validates :tax_inclusive, inclusion: { in: [true, false] }

  enum status: { active: 0, paused: 1, cancelled: 2 }
  enum payment_status: { pending: 0, paid: 1, failed: 2 }
  enum type: { monthly: 0, yearly: 1, one_time: 2 }
end