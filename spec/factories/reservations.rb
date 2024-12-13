FactoryBot.define do
  factory :reservation do
    concert
    status { "pending" }
    expires_at { "2024-12-11 16:45:40" }
  end
end
