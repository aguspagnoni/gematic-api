FactoryGirl.define do
  factory :order_item do
    quantity { Faker::Number.number(2) }
  end
end
