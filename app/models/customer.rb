class Customer < ApplicationRecord
  belongs_to :account
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_many :item_sold
  has_many :reservations, through: :item_sold
  has_many :reserved_items, through: :reservations, source: :item
end
