FactoryGirl.define do
  factory :discount do
    cents Faker::Number.number(2)
  end
end
