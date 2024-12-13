FactoryBot.define do
  factory :concert do
    name { "Classical Test" }
    description { "Test classical concert with violins" }
    date { "2024-12-11 16:41:46" }
    total_tickets { 100 }
    available_tickets { 150 }
    price { "9.99" }
  end
end
