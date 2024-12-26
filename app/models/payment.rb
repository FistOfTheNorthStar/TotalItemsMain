class Payment < ApplicationRecord
  belongs_to :subscription, optional: true
  belongs_to :user
  belongs_to :order, optional: true

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
  validates :provider, presence: true
  validates :payment_status, presence: true

  enum provider: {
    stripe: 0,
    paypal: 1,
    bank_transfer: 2
  }

  enum payment_status: {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3,
    refunded: 4
  }

  scope :completed, -> { where(payment_status: :completed) }
  scope :pending, -> { where(payment_status: :pending) }
  scope :failed, -> { where(payment_status: :failed) }
  scope :by_provider, ->(provider) { where(provider: provider) }
end