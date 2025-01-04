class User < ApplicationRecord
  include PhonePrefixes
  include CountryPrefixEmailValidation
  self.sanitized_fields += %w[ company_name vat_number ]

  has_many :orders
  has_many :trees
  has_one :subscription

  validates :country, :phone_prefix, numericality: { only_integer: true }
  validates :shopify_id, format: { with: /\A[0-9]+\z/, message: "must contain only numbers" },
            allow_nil: true,
            allow_blank: true

  # DO NOT CHANGE, ONLY ADD
  enum :role, [ :user, :company ]
end
