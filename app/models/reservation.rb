class Reservation < ApplicationRecord
  belongs_to :concert

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :tickets_available

  validates :status, presence: true
  validates :expires_at, presence: true

  private

  def tickets_available
    if quantity && concert && quantity > concert.available_tickets
      errors.add(:quantity, "exceeds available tickets")
    end
  end
end
