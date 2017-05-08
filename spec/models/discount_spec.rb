require 'rails_helper'

RSpec.describe Discount, type: :model do

  describe '#for_client_and_product' do
    let!(:client)      { create(:client) }
    let!(:client2)     { create(:client) }
    let!(:price_list)  { create(:price_list_with_products, client: client) }
    let!(:price_list2) { create(:price_list_with_products, client: client2) }
    let(:product)      { price_list.products.first }

    it 'select correct discount' do
      discount = Discount.for(client, product)
      expect(discount.product).to eq product
      expect(discount.client).to eq client
    end
  end
end
