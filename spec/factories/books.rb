FactoryBot.define do
  factory :book do
    title { "Atomic Habits" }
    isbn { "9783161484100" }
    description { "Good book" }
    publication_date { Date.current }
    total_copy_count { 10 }
    available_copy_count { 10 }
    genre { 3 }

    association :author
  end
end
