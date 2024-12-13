FactoryBot.define do
  factory :queue_position do
    user_token { "SECRET_TOKEN" }
    concert
    reservation_id { 1 }
    position { 1 }
    status { "queued" }
  end
end
