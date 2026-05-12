# To generate reusable test data objects.

FactoryBot.define do
  factory :member do
    sequence(:name) { |n| "Member #{n}" }
    sequence(:email) { |n| "member#{n}@test.com" }
    status { "active" }
    phone { "03556565734" }
  end
end
