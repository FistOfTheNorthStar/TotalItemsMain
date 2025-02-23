class Tree < ApplicationRecord
  belongs_to :user, optional: true
  include SharedValidators

  enum tree_state: { available: 0, reserved: 1, unavailable: 2 }

  validates :tree_state, presence: true

  validates :new_user_email,
    format: { with: ShareVariablesConstantsRegex::VALID_EMAIL_REGEX },
    if: -> { new_user_email.present? }

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
    sanitize_tree_info_fields
    generate_sha_if_new_user_email if new_user_email.present?
  end

  def sanitize_tree_info_fields
    %w[name description].each do |field|
      next unless self[field]
      self[field] = if self[field].is_a?(String)
        sanitize_string_fields(self[field])
      else
        sanitized_no_trunc(self[field])
      end
    end
  end

  def generate_sha_if_new_user_email
    salt = SecureRandom.hex(8)
    self.new_user_sha256 = Digest::SHA256.hexdigest(new_user_email + salt)
  end
end
