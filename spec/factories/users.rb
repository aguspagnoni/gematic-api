FactoryGirl.define do
  factory :user do
    email        { Faker::Internet.email }
    family_name  { Faker::Name.last_name }
    name         { Faker::Name.first_name }
    phone_number "MyString"
    cellphone    "MyString"
    password     { Faker::Internet.password(8) }
    company
  end
end
