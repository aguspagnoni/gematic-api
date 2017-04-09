FactoryGirl.define do
  factory :order do
    status 0
    delivery_date "2017-02-26"
    client
  end

  factory :order_with_products, parent: :order do
    after(:build) do |order|
      rand(1..3).times do
        product = FactoryGirl.create(:product)
        FactoryGirl.create(:order_item, product: product, order: order)
      end
      order.save!
    end
  end
end
