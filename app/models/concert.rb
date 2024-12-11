class Concert < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :queue_positions, dependent: :destroy

  validates :name, presence: true
  validates :date, presence: true
  validates :total_tickets, presence: true, numericality: { greater_than: 0 }
  validates :available_tickets, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def sold_out?
    available_tickets.zero?
  end

  def tickets_sold
    total_tickets - available_tickets
  end

  def percentage_sold
    ((tickets_sold.to_f / total_tickets) * 100).round(2)
  end
end
