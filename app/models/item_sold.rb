class ItemSold < ApplicationRecord
  belongs_to :item
  belongs_to :reservation
  belongs_to :customer
  has_one_attached :receipt
  has_one_attached :ticket
  has_many_attached :attachments

  before_create :generate_uuid

  validates :uuid, presence: true, uniqueness: true

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid unless self.uuid
  end
end
