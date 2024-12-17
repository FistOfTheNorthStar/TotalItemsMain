class Item < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :queue_positions, dependent: :destroy
  belongs_to :account
  has_many :item_sold
  has_many :customers, through: :item_sold

  validates :name, presence: true
  validates :date, presence: true
  validates :total_items, presence: true, numericality: { greater_than: 0 }
  validates :available_items, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :valid_until_date_check, if: -> { valid_until.present? }
  validate :reservation_limit_check, if: -> { reservation_limit.present? }

  def sold_out?
    available_items.zero?
  end

  def items_sold
    total_items - available_items
  end

  def percentage_sold
    ((items_sold.to_f / total_items) * 100).round(2)
  end

  private
  def valid_until_date_check
    if valid_until < Time.current
      errors.add(:valid_until, "can't be in the past")
    end
  end

  def reservation_limit_check
    if reservations.count >= reservation_limit
      errors.add(:base, "Maximum number of reservations reached")
    end
  end
end
