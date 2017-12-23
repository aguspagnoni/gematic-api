FactoryGirl.define do
  factory :order do
    status        0
    delivery_date "2017-02-26"
    company       { create(:company) }
    branch_office { create(:branch_office, company: company) }
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
