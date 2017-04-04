FactoryGirl.define do
  factory :order do
    status 0
    delivery_date "2017-02-26"
    client
  end
end
