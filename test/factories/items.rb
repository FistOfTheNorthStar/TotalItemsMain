# spec/factories/items.rb

# # Examples
# # Basic item
# item = create(:item)
#
# # Sellable item
# sellable = create(:item, :sellable)
#
# # Sold out item
# sold_out = create(:item, :sold_out)
#
# # Item with reservations
# with_reservations = create(:item, :with_reservations)
#
# # Item with specific price and dates
# custom = create(:item, price: 99.99, date: 3.months.from_now)
#
# # Minimal item with just required fields
# minimal = create(:item, :minimal)
#
# # Item with 50% sold
# partial = create(:item, :partially_sold)

FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Event #{n}" }
    description { "A fantastic event description" }
    date { 2.weeks.from_now }
    total_items { 100 }
    available_items { 100 }
    price { 29.99 }
    association :account
    valid_until { 1.week.from_now }
    reservation_limit { 10 }
    sale_start_time { 1.day.from_now }

    trait :sellable do
      valid_until { 1.week.from_now }
      sale_start_time { 1.minute.ago }
      available_items { 10 }
    end

    trait :sold_out do
      available_items { 0 }
    end

    trait :sale_not_started do
      sale_start_time { 1.day.from_now }
    end

    trait :expired do
      valid_until { 1.day.ago }
    end

    trait :with_reservations do
      after(:create) do |item|
        create_list(:reservation, 3, item: item)
        item.update(available_items: item.total_items - 3)
      end
    end

    trait :at_reservation_limit do
      reservation_limit { 5 }
      after(:create) do |item|
        create_list(:reservation, 5, item: item)
        item.update(available_items: item.total_items - 5)
      end
    end

    trait :with_customers do
      after(:create) do |item|
        create_list(:sold_item, 3, item: item)
      end
    end

    trait :without_optional_dates do
      valid_until { nil }
      sale_start_time { nil }
      reservation_limit { nil }
    end

    trait :minimal do
      description { nil }
      valid_until { nil }
      sale_start_time { nil }
      reservation_limit { nil }
    end

    trait :partially_sold do
      after(:create) do |item|
        sold_amount = item.total_items / 2
        item.update(available_items: item.total_items - sold_amount)
      end
    end
  end
end
