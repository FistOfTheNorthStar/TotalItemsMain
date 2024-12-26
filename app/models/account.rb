class Account < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :sold_items, through: :items

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end


