class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :subscription, optional: true
  belongs_to :order, optional: true

  validates :payment_status, presence: true

  validates :amount, :tax, :tax_percentage, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
  validates :provider, :payment_status, presence: true
  validates :tax_inclusive, inclusion: { in: [true, false] }

  enum :provider, [ stripe: 0, paypal: 1 ]
  enum :payment_status, [ :pending, :processing, :completed, :failed, :refunded ]

  scope :completed, -> { where(payment_status: :completed) }
  scope :refunded, -> { where(payment_status: :refunded) }
  scope :processing, -> { where(payment_status: :processing) }
  scope :pending, -> { where(payment_status: :pending) }
  scope :failed, -> { where(payment_status: :failed) }
  scope :by_provider, ->(provider) { where(provider: provider) }
end
