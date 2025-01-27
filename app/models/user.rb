class User < ApplicationRecord
  include PhonePrefixes
  include CountryPrefixEmailValidation
  self.sanitized_fields += %w[ company_name vat_number ]

  has_many :orders
  has_many :trees
  has_many :payments

  validates :country, :phone_prefix, numericality: { only_integer: true }
  validates :shopify_id, format: { with: /\A[0-9]+\z/, message: "must contain only numbers" },
            allow_nil: true,
            allow_blank: true

  validates :chargebee_id, format: { with: /\A[0-9a-zA-Z]+\z/, message: "must contain only numbers or letters" },
            allow_nil: true,
            allow_blank: true

  # DO NOT CHANGE, ONLY ADD
  enum :role, [ :consumer, :business ]
  enum :subscription_tree_type, [ :yemani, :mango_tree ]
  enum :subscription_type, [ :regular, :family, :company ]
  enum :subscription_status, [ :none, :active, :cancelled, :deleted ]
end
