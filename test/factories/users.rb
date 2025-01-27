FactoryBot.define do
  sequence :shopify_id do |n|
    "#{1234567 + n}"
  end

  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    address_1 { "123 'Main St&<img>" }
    phone { "555-1234" }
    first_name { "John" }
    last_name { "Doe" }
    address_2 { "Apt 4" }
    city { "Test City" }
    state { "ON" }
    country { 0 }
    phone_prefix { 0 }
    role { :consumer }
    shopify_id { "" }

    trait :business do
      role { :business }
      company_name { "Test Company" }
    end

    trait :with_shopify do
      shopify_id { generate(:shopify_id) }
    end
  end
end
