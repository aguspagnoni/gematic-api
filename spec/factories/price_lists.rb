FactoryGirl.define do
  factory :price_list do
  end

  factory :price_list_with_products, parent: :price_list do
    after(:build) do |price_list|
      rand(1..3).times do
        product  = FactoryGirl.create(:product)
        discount = FactoryGirl.create(:discount, product: product, price_list: price_list)
      end
    end
  end
end
