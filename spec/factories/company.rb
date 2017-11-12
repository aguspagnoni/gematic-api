FactoryGirl.define do
  factory :company do
    name         { Faker::Lorem.sentence }
    address      { Faker::Lorem.sentence }
    cuit         { Faker::Lorem.sentence }
    condition    { Faker::Lorem.sentence }
    razon_social { Faker::Lorem.sentence }
  end
end
