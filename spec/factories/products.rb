FactoryGirl.define do
  factory :product do
    name          { Faker::Lorem.sentence }
    code          { Faker::Lorem.sentence }
    description   { Faker::Lorem.sentence }
    gross_price   { Faker::Number.number(4) }
    cost          { Faker::Number.number(2) }
  end
end
