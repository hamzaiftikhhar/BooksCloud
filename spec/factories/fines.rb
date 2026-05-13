FactoryBot.define do
  factory :fine do
    association :borrowing
    amount_due { 100 }
    amount_paid { 0 }
    status { "outstanding" }
  end
end
