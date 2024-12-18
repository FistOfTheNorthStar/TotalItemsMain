class Reservation < ApplicationRecord
  belongs_to :item
  has_many :item_sold
  has_one :customer

  delegate :account, to: :item

  validates :quantity, presence: true, numericality: { greater_than_or_equal: 0 }
  validates :status, presence: true
  validate :within_reservation_limit

  after_commit :broadcast_status_change, if: :saved_change_to_status?

  enum :status, [ :pending, :payment_begin, :payment_end, :canceled, :expired, :failed, :completed ]

  scope :pending_and_expiring_soon, ->() { where(status: "pending", expires_at: Time.current..5.minutes.from_now) }
  scope :pending_and_old, -> {
    pending
      .where("created_at <= ?", 15.minutes.ago)
  }

  private

  def within_reservation_limit
    if item.reservation_limit.present? &&
      quantity > item.reservation_limit
      errors.add(:base, "This item has reached its reservation limit")
    end
  end

  def broadcast_status_change
    ReservationStatusBroadcaster.new(id, status).broadcast
  end
end
