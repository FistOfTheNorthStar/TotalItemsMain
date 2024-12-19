# spec/factories/sold_item.rb

# # EXAMPLES
# # Basic item sold
# sold_item = create(:sold_item)
#
# # With receipt
# with_receipt = create(:sold_item, :with_receipt)
#
# # With all attachments
# full_item = create(:sold_item, :with_all_attachments)
#
# # Test UUID generation
# auto_uuid = create(:sold_item, :without_uuid)

FactoryBot.define do
  factory :sold_item do
    association :reservation
    association :customer
    uuid { SecureRandom.uuid }

    trait :with_receipt do
      after(:build) do |sold_item|
        sold_item.receipt.attach(
          io: StringIO.new("receipt content"),
          filename: "receipt.pdf",
          content_type: "application/pdf"
        )
      end
    end

    trait :with_ticket do
      after(:build) do |sold_item|
        sold_item.ticket.attach(
          io: StringIO.new("ticket content"),
          filename: "ticket.pdf",
          content_type: "application/pdf"
        )
      end
    end

    trait :with_attachments do
      after(:build) do |sold_item|
        2.times do |n|
          sold_item.attachments.attach(
            io: StringIO.new("attachment content #{n}"),
            filename: "attachment#{n}.pdf",
            content_type: "application/pdf"
          )
        end
      end
    end

    trait :with_all_attachments do
      with_receipt
      with_ticket
      with_attachments
    end

    # Test auto-generation of UUID
    trait :without_uuid do
      uuid { nil }
    end
  end
end
