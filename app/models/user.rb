class User < ApplicationRecord
  has_many :orders
  validates :email, presence: true, format: { with: ShareVariablesConstantsRegex::VALID_EMAIL_REGEX }
  before_save :clean_inputs

  def shipping_address
    if self[:shipping_address]
      ERB::Util.html_escape(
        CGI.unescape(self[:shipping_address])
      )
    end
  end

  private
  def clean_inputs
    self.shipping_address = clean_address(shipping_address) if shipping_address.present?
    self.phone = clean_phone(phone) if phone.present?
  end

  def clean_address(value)
    value
      .strip
      .gsub(/[[:space:]]+/, " ")
      .truncate(255, omission: "")
      .then { |cleaned| CGI.escape(cleaned) }
  end

  def clean_phone(number)
    number
      .strip
      .gsub(/[^+()\d\-\s]/, "")
      .gsub(/[[:space:]]+/, "")
      .truncate(20, omission: "")
  end
end
