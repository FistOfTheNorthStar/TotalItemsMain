FactoryBot.define do
  factory :payment do
    amount { "9.99" }
    currency { "MyString" }
    provider { 1 }
    payment_status { 1 }
    subscription { nil }
    user { nil }
    order { nil }
    token { "MyText" }
    payment_date { "2024-12-26 10:21:21" }
    provider_confirmation_id { "MyText" }
  end
end
