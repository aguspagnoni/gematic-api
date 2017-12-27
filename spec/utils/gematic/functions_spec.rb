require 'rails_helper'

describe Utils::Gematic::Functions do

  subject { described_class }

  describe '#duplicate_order' do
    let!(:original_order) { create(:order_with_products) }
    let(:new_order)       { Order.last }

    it 'should create a new order with the same products and quantities' do
      expect { subject.duplicate_order(original_order) }
        .to change(Order, :count).by(1)
      expect(new_order.status).to eq 'not_confirmed'
      expect(new_order.delivery_date).to eq nil
      expect(new_order.company).to eq original_order.company
      expect(new_order.branch_office).to eq original_order.branch_office
      expect(new_order.custom_price_list).to eq original_order.custom_price_list
      expect(new_order.name).to eq "Copia de Pedido Numero #{original_order.id} #{original_order.name}"
      expect(list_of_items(new_order)).to match_array(list_of_items(original_order))
    end

    context 'when order has custom price_list' do
      let!(:price_list)     { create(:price_list_with_company_and_products) }
      let!(:original_order) { create(:order_with_products, custom_price_list: price_list) }

      before do
        subject.duplicate_order(original_order)
      end

      it { expect(new_order.custom_price_list).to eq original_order.custom_price_list }
    end
  end

  describe '#populate_order_with_price_list' do
    context 'when the order has no custom PriceList' do
      let!(:price_list) { create(:price_list_with_company_and_products) }
      let(:order)       { create(:order, company: price_list.company) }

      it 'fills the order with products from the existing PriceList' do
        expect(price_list.products.count).to be_positive
        expect { subject.populate_order_with_price_list(order) }
          .to change(OrderItem, :count).by(price_list.products.count)
        expect(Order.last.order_items.pluck(:quantity)).to all eq 0
      end
    end

    context 'when the order has a custom PriceList' do
      let!(:price_list)        { create(:price_list_with_company_and_products) }
      let!(:custom_price_list) { create(:price_list_with_company_and_products) }
      let!(:product)            { create(:product) }
      let!(:discount)           { create(:discount, product: product, price_list: custom_price_list)}

      let(:order)              { create(:order, company: price_list.company,
                                                custom_price_list: custom_price_list) }

      it 'fills the order with products from the custom PriceList' do
        expect { subject.populate_order_with_price_list(order) }
          .to change(OrderItem, :count).by(custom_price_list.products.count)
        expect(Order.last.products).to include(product)
      end
    end
  end
end

def list_of_items(order)
  order.order_items.pluck(:product_id, :quantity)
end
