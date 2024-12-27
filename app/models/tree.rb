class Tree < ApplicationRecord
  belongs_to :user, optional: true
  include SharedValidators


  validates :price, :tax, :tax_percentage, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
  validates :tree_state, presence: true
  validates :tax_inclusive, inclusion: { in: [true, false] }

  enum :tree_state, [ :available, :reserved, :unavailable ]

  def sanitize_personal_fields
    %w[ name description].each do |field|
      self[field] = self[field].is_a?(String) ? sanitize_string_fields(self[field]) : sanitized_no_trunc(self[field])
    end
    %w[gps_longitus ]
  end
end