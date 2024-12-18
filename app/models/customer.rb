class Customer < ApplicationRecord
  belongs_to :account
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_many :item_sold
  has_many :reservations, through: :item_sold
  has_many :reserved_items, through: :reservations, source: :item
  before_save :clean_inputs

  private

  def clean_inputs
    self.shipping_address = clean_address(shipping_address) if shipping_address.present?
    self.phone = clean_phone(phone) if phone.present?
  end
  def clean_address(value)
    CGI.escape(value)
      .strip
      .gsub(/\s+/, " ")
      .truncate(255, omission: "")
  end

  def clean_phone(number)
    number
      .strip
      .gsub(/[^+()0-9\-\s]/, "")
      .gsub(/\s+/, " ")
  end
end
