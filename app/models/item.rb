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

  def sold_out?
    available_items.zero?
  end

  def items_sold
    total_items - available_items
  end

  def percentage_sold
    ((items_sold.to_f / total_items) * 100).round(2)
  end
end
