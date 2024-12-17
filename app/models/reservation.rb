class Reservation < ApplicationRecord
  belongs_to :item
  has_many :item_sold
  has_one :customer

  validates :quantity, presence: true, numericality: { greater_than_or_equal: 0 }
  validate :items_available
  validates :status, presence: true
  validates :expires_at, presence: true
  validate :within_reservation_limit

  scope :pending_and_expiring_soon, ->() { where(status: "pending", expires_at: Time.current..5.minutes.from_now) }

  def expired?
    expires_at < Time.current
  end

  private

  def items_availables
    if quantity && concert && quantity > concert.available_items
      errors.add(:quantity, "exceeds available tickets")
    end
  end

  def within_reservation_limit
    if item.reservation_limit.present? &&
      item.reservations.count >= item.reservation_limit
      errors.add(:base, "This item has reached its reservation limit")
    end
  end
end
