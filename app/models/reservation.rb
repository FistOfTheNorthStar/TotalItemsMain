class Reservation < ApplicationRecord
  belongs_to :item

  validates :quantity, presence: true, numericality: { greater_than_or_equal: 0 }
  validate :items_available
  validates :status, presence: true
  validates :expires_at, presence: true

  scope :pending_and_expiring_soon, ->() { where(status: "pending", expires_at: Time.current..5.minutes.from_now) }


  def expired?
    expires_at < Time.current
  end

  private

  def items_available
    if quantity && concert && quantity > concert.available_items
      errors.add(:quantity, "exceeds available tickets")
    end
  end
end
