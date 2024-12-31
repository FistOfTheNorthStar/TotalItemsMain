class Product < ApplicationRecord
  include SharedValidators
  before_validation :sanitize_fields

  validates :name,
            presence: true,
            length: { maximum: 255 }

  validates :description,
            length: { maximum: 10000 },
            allow_nil: true

  validates :price,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than: 1_000_000_000 # Sensible maximum
            }

  validates :tax_percentage,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            }

  validates :number_available,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: -1
            },
            allow_nil: true

  validates :sales_start_date,
            comparison: {
              less_than: :sales_stop_date,
              allow_nil: true
            }

  validates :sales_stop_date,
            comparison: {
              greater_than: :sales_start_date,
              allow_nil: true
            }

  # DO NOT CHANGE ORDER
  enum :type, [ :tree, :donation, :subscription, :family_subscription ]

  private

  def sanitize_fields
    self.name = sanitize_string_fields(name) if name.present?
    self.description = sanitized_no_trunc(description) if description.present?
  end

  def validate_sales_dates
    if sales_start_date.present? && sales_start_date < Time.current
      errors.add(:sales_start_date, "can't be in the past")
    end

    if sales_stop_date.present? && sales_start_date.present?
      if sales_stop_date <= sales_start_date
        errors.add(:sales_stop_date, "must be after start date")
      end
    end
  end
end
