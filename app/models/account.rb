class Account < ApplicationRecord
  has_many :items
  has_many :customers
  has_many :item_sold, through: :items

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
