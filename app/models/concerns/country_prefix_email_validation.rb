module CountryPrefixEmailValidation
  extend ActiveSupport::Concern
  include SharedValidators

  included do
    class_attribute :sanitized_fields, instance_writer: false
    self.sanitized_fields = %w[ first_name last_name address_1 address_2 city phone, state ]

    validates :phone_prefix,
              numericality: {
                only_integer: true,
                greater_than_or_equal_to: 0,
                less_than_or_equal_to: 160,
                message: "must be an integer between 0 and 160"
              }

    validates :country,
              numericality: {
                only_integer: true,
                greater_than_or_equal_to: 0,
                less_than_or_equal_to: 160,
                message: "must be an integer between 0 and 160"
              }

    validates :email, presence: true, format: { with: ShareVariablesConstantsRegex::VALID_EMAIL_REGEX }

    before_validation :sanitize_personal_fields
  end

  def sanitize_personal_fields
    sanitized_fields.each do |field|
      next unless self.respond_to?(field)
      if self[field].is_a?(String)
        self[field] = field.to_s == "phone" ? sanitize_string_fields(self[field].to_s) : sanitize_phone(self[field].to_s)
      else
        self[field] = sanitized_no_trunc(self[field].to_s)
      end
    end
  end
end