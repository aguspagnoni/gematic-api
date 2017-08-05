FactoryGirl.define do
  factory :admin_user do
    privilege   1
    name        { Faker::Name.first_name }
    email       { Faker::Internet.email }
    family_name { Faker::Name.last_name }
    password    'asd'
  end
end
