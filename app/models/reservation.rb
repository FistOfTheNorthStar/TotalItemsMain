class Reservation < ApplicationRecord
  belongs_to :item
  has_many :sold_items, dependent: :destroy
  has_many :users, through: :sold_items

  delegate :account, to: :item

  validates :quantity, presence: true, numericality: { greater_than_or_equal: 0 }
  validates :status, presence: true
  validate :within_reservation_limit

  after_commit :broadcast_status_change, if: :saved_change_to_status?

  enum :status, [ :pending, :payment_begin, :payment_end, :canceled, :expired, :failed, :completed ]

  scope :pending_and_old, -> {
    pending
      .where("created_at <= ?", 15.minutes.ago)
  }

  private

  def within_reservation_limit
    if item && quantity && item.reservation_limit.present? &&
      quantity > item.reservation_limit
      errors.add(:base, "This item has reached its reservation limit")
    end
  end

  def broadcast_status_change
    ReservationStatusBroadcaster.new(id, status).broadcast
  end
end
