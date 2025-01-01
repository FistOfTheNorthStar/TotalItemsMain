# # spec/factories/accounts.rb
#
# # # EXAMPLE USE # #
# # Basic account
# # account = create(:account)
# #
# # # Account with items
# # account_with_items = create(:account, :with_items)
# #
# # # Account with customers
# # account_with_customers = create(:account, :with_customers)
# #
# # # Account with both
# # account_full = create(:account, :with_items_and_customers)
# #
# # # Account with sales (no tests yet)
# # account_with_sales = create(:account, :with_sold_items)
# #
# # # Invalid account for testing
# # invalid_account = build(:invalid_account)
# # #
#
# FactoryBot.define do
#   factory :account do
#     name { Faker::Company.name }
#     sequence(:email) { |n| "account#{n}@#{Faker::Internet.domain_name}" }
#
#     trait :with_items do
#       after(:create) do |account|
#         create_list(:item, 3, account: account)
#       end
#     end
#
#     trait :with_customers do
#       after(:create) do |account|
#         create_list(:customer, 3, account: account)
#       end
#     end
#
#     trait :with_items_and_customers do
#       after(:create) do |account|
#         create_list(:item, 3, account: account)
#         create_list(:customer, 3, account: account)
#       end
#     end
#
#     trait :with_sold_items do
#       after(:create) do |account|
#         customer = create(:customer, account:)
#         items = create_list(:item, 3, account:)
#         items.each do |item|
#           create(:sold_item, item:, customer:)
#         end
#       end
#     end
#
#     factory :invalid_account do
#       name { nil }
#       email { nil }
#     end
#   end
# end
#
#
