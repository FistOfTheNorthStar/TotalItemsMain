class Item < ApplicationRecord
  has_many :reservations, dependent: :destroy
  belongs_to :account
  has_many :sold_items, through: :reservations
  has_many :customers, through: :sold_items

  validates :name, presence: true
  validates :date, presence: true
  validates :total_items, presence: true, numericality: { greater_than: 0 }
  validates :available_items, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :valid_until_date_check, if: -> { valid_until.present? }
  validate :reservation_limit_check, if: -> { reservation_limit.present? }
  validate :sale_start_time_check, if: -> { sale_start_time.present? }

  scope :sellable_items, -> do
    where(sellable_conditions)
  end

  scope :sellable_item, ->(item_id) do
    where(id: item_id)
      .where(sellable_conditions)
      .limit(1)
      .first
  end

  def availability
    current_time = Time.current
    ((valid_until.present? && valid_until <= current_time) ||
      (sale_start_time.present? && sale_start_time >= current_time) ||
      available_items == 0) ? 0 : available_items
  end

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

  def self.sellable_conditions
    current_time = Time.current
    [
      '(valid_until IS NULL OR valid_until > ?) AND
     (sale_start_time IS NULL OR sale_start_time <= ?) AND
     available_items > 0',
      current_time,
      current_time
    ]
  end

  def reservation_limit_check
    if reservations.count >= reservation_limit
      errors.add(:base, "Maximum number of reservations reached")
    end
  end

  def sale_start_time_check
    if sale_start_time < Time.current
      errors.add(:sale_start_time, "Selling start cannot be in the past")
    end
  end
end
