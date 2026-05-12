FactoryBot.define do
  factory :book do
    title { "Atomic Habits" }

    sequence(:isbn) { |n| "9781234567#{n.to_s.rjust(3, '0')}" }

    description { "Good book" }
    publication_date { Date.current }
    total_copy_count { 10 }
    available_copy_count { 10 }
    genre { 3 }

    association :author
  end
end
