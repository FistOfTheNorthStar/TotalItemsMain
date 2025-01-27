class Payment < ApplicationRecord
  belongs_to :user, optional: true
  validates :payment_status, presence: true
  validates :currency, presence: true
  validates :provider, :payment_status, presence: true
  validates :tax_inclusive, inclusion: { in: [ true, false ] }

  enum :provider, [ :chargebee, :invoice, :bank, :cash, :other ]
  enum :payment_status, [ :pending, :order_created, :completed, :failed, :refunded ]

  scope :completed, -> { where(payment_status: :completed) }
  scope :refunded, -> { where(payment_status: :refunded) }
  scope :order_created, -> { where(payment_status: :order_created) }
  scope :pending, -> { where(payment_status: :pending) }
  scope :failed, -> { where(payment_status: :failed) }
  scope :refund_started, -> { where(payment_status: :refund_started) }
  scope :by_provider, ->(provider) { where(provider: provider) }
end
