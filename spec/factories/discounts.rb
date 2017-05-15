FactoryGirl.define do
  factory :discount do
    cents { Faker::Number.number(1) }
  end
end
