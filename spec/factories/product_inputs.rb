FactoryGirl.define do
  factory :product_input do
    quantity          { Faker::Number.number(2) }
    unit_price        { Faker::Number.number(4) }
    reference_number  { Faker::Lorem.sentence }
    image             { Faker::Lorem.sentence }
    admin_user
    product
    seller_company    { create(:billing_info) }
    buyer_company     { create(:billing_info) }
  end
end
