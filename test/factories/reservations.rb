# spec/factories/reservations.rb

# # Examples
# # Basic pending reservation
# reservation = create(:reservation)
#
# # Completed reservation with customer
# completed = create(:reservation, :completed, :with_customer)
#
# # Test expiring soon scope
# expiring = create(:reservation, :expiring_soon)
#
# # Test old pending scope
# old = create(:reservation, :old_pending)
#
# # Test over limit validation
# invalid = build(:reservation, :over_limit)
#
# # Test status broadcast
# broadcasting = create(:reservation, :will_change_status)

FactoryBot.define do
  factory :reservation do
    association :item
    quantity { 1 }
    uuid { SecureRandom.uuid }
    status { :pending }

    # Different status states
    trait :payment_begin do
      status { :payment_begin }
    end

    trait :payment_end do
      status { :payment_end }
    end

    trait :canceled do
      status { :canceled }
    end

    trait :expired do
      status { :expired }
    end

    trait :failed do
      status { :failed }
    end

    trait :completed do
      status { :completed }
    end

    trait :with_sold_item do
      after(:create) do |reservation|
        create(:sold_item, reservation: reservation)
      end
    end

    trait :with_customer do
      after(:create) do |reservation|
        create(:sold_item, reservation: reservation, customer: create(:customer))
      end
    end

    trait :expiring_soon do
      created_at { 4.minutes.ago }
    end

    trait :old_pending do
      status { :pending }
      created_at { 16.minutes.ago }
    end

    trait :over_limit do
      after(:build) do |reservation|
        reservation.item.update(reservation_limit: 1)
        reservation.quantity = 2
      end
    end

    trait :multiple_items do
      quantity { 3 }
    end

    trait :will_change_status do
      after(:create) do |reservation|
        reservation.status = :completed
      end
    end
  end
end