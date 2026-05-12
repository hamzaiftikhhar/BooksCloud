FactoryBot.define do
  factory :borrowing do
    association :member
    association :book

    issue_date { Time.current }
    due_date { 14.days.from_now }
    status { :active }
    fine_amount { 0.0 }
    fine_paid { false }
    reminder_sent { false }
    return_date { nil }

    trait :returned do
      status { :returned }
      return_date { Time.current }
    end

    trait :overdue do
      due_date { 2.days.ago }
    end
  end
end
