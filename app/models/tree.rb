class Tree < ApplicationRecord
  belongs_to :user, optional: true
  include SharedValidators

  validates :price, :tax, :tax_percentage, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
  validates :tree_state, presence: true
  validates :tax_inclusive, inclusion: { in: [true, false] }

  enum :tree_state, [ :available, :reserved, :unavailable ]

  validates :new_user_email, presence: true, format: { with: ShareVariablesConstantsRegex::VALID_EMAIL_REGEX } if new_user_email.present?
  validates :gps_latitude,
            numericality: {
              greater_than_or_equal_to: -90,
              less_than_or_equal_to: 90,
              allow_nil: true
            }
  validates :gps_longitude,
            numericality: {
              greater_than_or_equal_to: -180,
              less_than_or_equal_to: 180,
              allow_nil: true
            }
  before_save :sanitize_and_check_donation

  private

  def sanitize_and_check_donation
    sanitize_and_check_donation if new_user_email.present?
    sanitize_tree_info_fields
  end

  def sanitize_tree_info_fields
    %w[ name description ].each do |field|
      self[field] = self[field].is_a?(String) ? sanitize_string_fields(self[field]) : sanitized_no_trunc(self[field])
    end
  end

  def generate_sha_if_new_user_email
    salt = SecureRandom.hex(8)
    self.new_user_sha256 = Digest::SHA256.hexdigest(new_user_email + salt)
  end
end