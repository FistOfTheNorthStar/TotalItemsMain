FactoryBot.define do
  factory :concert do
    name { "MyString" }
    description { "MyText" }
    date { "2024-12-11 16:41:46" }
    total_tickets { 1 }
    available_tickets { 1 }
    price { "9.99" }
  end
end
