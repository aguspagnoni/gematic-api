require 'rails_helper'

RSpec.describe PriceList, type: :model do
  let(:gross_price)         { 100 }
  let!(:product_w_discount) { create(:product, gross_price: gross_price) }
  let!(:default_product)    { create(:product, gross_price: gross_price) }
  let!(:price_list)         { create(:price_list) }

  let!(:discount)           { create(:discount, price_list: price_list, product: product_w_discount) }
  let(:list_details)        { { product: product_w_discount, discount: discount } }

  it { expect(product_w_discount.gross_price).to eq gross_price }
  it { expect(price_list.products).to include product_w_discount }
  it { expect(price_list.products).not_to include default_product }
  it 'has details of those products that a discount is applied' do
    expect(price_list.details).to match_array(a_hash_including(list_details))
  end
end
