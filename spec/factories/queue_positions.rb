FactoryBot.define do
  factory :queue_position do
    user_token { "MyString" }
    concert { nil }
    position { 1 }
    status { "MyString" }
  end
end
