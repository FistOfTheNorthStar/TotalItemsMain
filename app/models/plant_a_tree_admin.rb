class PlantATreeAdmin < ApplicationRecord
  include PhonePrefixes
  include CountryPrefixEmailValidation
  self.sanitized_fields += %w[ name description important ]

  validates :email, uniqueness: true
  validates :address_1, :first_name, :last_name, :state, :address_2, :city, :title, presence: true
  validates :country, :phone_prefix, :role, presence: true, numericality: { only_integer: true }
  validates :phone_prefix, presence: true
  validates :phone_prefix, inclusion: { in: PHONE_PREFIXES.keys }

  # DO NOT CHANGE, ONLY ADD
  enum :role, [ :super_admin, :admin, :manager ]
end


