FactoryBot.define do
  factory :author do
    sequence(:first_name) { |n| "John#{n}" }
    sequence(:last_name)  { |n| "Doe#{n}" }
  end
end

# output will be

# John1 Doe1
# John2 Doe2
# John3 Doe3
