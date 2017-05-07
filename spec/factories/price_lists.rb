FactoryGirl.define do
  factory :price_list do
    name { Faker::Lorem.sentence(3) }
  end

  factory :price_list_with_products, parent: :price_list do
    after(:build) do |price_list|
      rand(1..3).times do
        product = FactoryGirl.create(:product)
        FactoryGirl.create(:discount, product: product, price_list: price_list)
      end
      price_list.save!
    end
  end
end
