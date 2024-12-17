class QueuePosition < ApplicationRecord
  belongs_to :item

  scope :expiring_soon, ->() { where(expires_at: Time.current..5.minutes.from_now) }
end
