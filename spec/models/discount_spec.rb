require 'rails_helper'

RSpec.describe Discount, type: :model do
  let!(:client)      { create(:client) }

  describe '#for_client_and_product' do
    let!(:client2)     { create(:client) }
    let!(:price_list)  { create(:price_list_with_products, client: client) }
    let!(:price_list2) { create(:price_list_with_products, client: client2) }
    let(:product)      { price_list.products.first }

    it 'select correct discount' do
      discount = Discount.for_client_and_product(client, product)
      expect(discount.product).to eq product
      expect(discount.client).to eq client
    end
  end

  context 'when discount is bigger than producs cost' do
    let(:product)    { create(:product, cost: 100) }
    let(:price_list) { create(:price_list, client: client) }
    let(:error_msg)  { I18n.t 'errors.messages.discount_cents_greater_product_cost' }
    let(:discount) do
      build(:discount, cents: product.cost + 1, price_list: price_list, product: product)
    end

    it 'fails with correct message' do
      expect(discount.valid?).to be false
      expect(discount.errors.messages[:cents].first).to eq error_msg
    end
  end
end
