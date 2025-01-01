# # spec/factories/customers.rb
#
# # # EXAMPLES
# # # Basic customer
# # customer = create(:customer)
# #
# # # User with reservations
# # customer_with_reservations = create(:customer, :with_reservations)
# #
# # # User without address or phone
# # customer_minimal = create(:customer, :without_address, :without_phone)
# #
# # # Testing cleaning
# # customer_clean = create(:customer, :with_invalid_phone, :with_special_chars_address)
#
# FactoryBot.define do
#   factory :user do
#     sequence(:email) { |n| "customer#{n}@example.com" }
#     shipping_address { "123 Test St, City, State 12345" }
#     phone { "+1 (555) 123-4567" }
#     association :account
#
#     trait :with_reservations do
#       after(:create) do |customer|
#         create_list(:sold_item, 2, customer: customer).each do |sold_item|
#           create(:reservation, sold_item:)
#         end
#       end
#     end
#
#     trait :with_reserved_items do
#       after(:create) do |customer|
#         create_list(:item, 2).each do |item|
#           sold_item = create(:sold_item, customer: customer, item: item)
#           create(:reservation, sold_item:)
#         end
#       end
#     end
#
#     trait :without_address do
#       shipping_address { nil }
#     end
#
#     trait :without_phone do
#       phone { nil }
#     end
#
#     trait :with_invalid_phone do
#       phone { "abc123" }
#     end
#
#     trait :with_long_address do
#       shipping_address { "a" * 300 }
#     end
#
#     trait :with_special_chars_address do
#       shipping_address { "123 & Main St. #apt 4" }
#     end
#   end
# end
