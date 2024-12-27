class User < ApplicationRecord
  include PhonePrefixes
  include CountryPrefixEmailValidation

  has_many :orders
  before_save :clean_inputs
  before_validation :sanitize_fields

  private

  def sanitize_fields
    self.email = sanitize_string_fields(email) if email.present?
    self.first_name = sanitize_string_fields(first_name) if first_name.present?
    self.last_name = sanitize_string_fields(last_name) if last_name.present?
    self.address_1 = sanitize_string_fields(address_1) if address_1.present?
    self.address_2 = sanitize_string_fields(address_2) if address_2.present?
    self.city = sanitize_string_fields(city) if city.present?
    self.phone = sanitize_phone_field(phone) if phone.present?
  end

  def clean_inputs
    self.shipping_address = clean_address(shipping_address) if shipping_address.present?
  end


end
