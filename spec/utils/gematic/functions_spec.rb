require 'rails_helper'

describe Utils::Gematic::Functions do
  subject { described_class }

  describe '#duplicate_order' do
    let!(:original_order) { create(:order_with_products) }
    let(:new_order)       { Order.last }

    it 'should create a new order with the same products and quantities' do
      expect { subject.duplicate_order(original_order) }
        .to change(Order, :count).by(1)
      expect(new_order.status).to eq 'presupuesto'
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

  describe '#duplicate_list' do
    let(:admin_user) { create(:admin_user) }
    let!(:original_price_list) do
      create(:price_list_with_company_and_products, authorized_at: Time.zone.now,
                                                    authorizer_id: admin_user.id)
    end
    let(:new_list) { PriceList.last }

    it 'should create a new list with same everything but the name' do
      expect { subject.duplicate_list(original_price_list) }
        .to change(PriceList, :count).by(1)
      expect(new_list.company).to eq(original_price_list.company)
      expect(new_list.name).to eq('Copy of ' + original_price_list.name)
      expect(new_list.expires).to eq(original_price_list.expires)
      expect(new_list.valid_since).to eq(original_price_list.valid_since) # WARN: this may lead to unespected behaviour if there is an order to the company without a Custom PriceList, because this new duplicated pricelist will be the chosen one for upcoming orders.
      expect(new_list.authorized_at).to be_nil
      expect(new_list.authorizer_id).to be_nil
      expect(list_of_discounts(new_list)).to match_array(list_of_discounts(original_price_list))
    end
  end

  describe '#populate_order_with_price_list' do
    context 'when the order has no custom PriceList' do
      let!(:price_list) { create(:price_list_with_company_and_products) }
      let(:order)       { create(:order, company: price_list.company) }

      it 'fills the order with products from the existing PriceList' do
        expect(price_list.products.count).to be_positive
        expect { subject.populate_order_with_price_list(order, price_list) }
          .to change(OrderItem, :count).by(price_list.products.count)
        expect(Order.last.order_items.pluck(:quantity)).to all eq 0
      end
    end
  end
end

def list_of_items(order)
  order.order_items.pluck(:product_id, :quantity)
end

def list_of_discounts(price_list)
  price_list.discounts.pluck(:cents, :product_id, :fixed, :final_price)
end
