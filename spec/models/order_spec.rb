require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should have_many :products }
  it { should belong_to :company }

  context 'status' do
    let(:order) { create(:order, status: :not_confirmed) }

    it 'does not allow any status as valid' do
      expect { build(:order, status: 999) }.to raise_error(ArgumentError)
    end

    it 'changes status accordingly' do
      expect { order.confirmed! }.to change(order, :status).from('not_confirmed').to('confirmed')
    end
  end

  context 'when calculating totals and subtotal' do
    let(:company)      { create(:company) }
    let(:price_list)  { create(:price_list, company: company) }
    let(:product_1)   { create(:product, gross_price: 100, cost: 99) }
    let(:product_2)   { create(:product, gross_price: 200, cost: 199) }
    let(:product_3)   { create(:product, gross_price: 1000, cost: 999) }
    let!(:discount_1) { create(:discount, cents: 50, product: product_1, price_list: price_list) }
    let!(:discount_2) { create(:discount, cents: 150, product: product_2, price_list: price_list) }
    let(:order)       { create(:order, company: price_list.company) }
    let(:products)    { [product_1, product_2] }

    before do
      products.map do |product|
        create(:order_item, product: product, order: order, quantity: 1)
      end
    end

    context 'when all products of an order is inside a price list' do
      let(:expected_simple_gross)     { 300 } # p1 + p2
      let(:expected_gross_w_discount) { 100 } # (p1 - d1) + (p2 - d2)

      it 'should not use the default prices' do
        expect(order.gross_total).not_to eq expected_simple_gross
      end

      it 'should use every discount for the products that are inside the price list' do
        expect(order.gross_total).to eq expected_gross_w_discount
      end
    end

    context 'when some products of an order are inside a price list' do
      let(:expected_gross_w_discount) { 1100 } # (p1 - d1) + (p2 - d2) + p3
      let(:products) { [product_1, product_2, product_3] }

      it 'should use discounts for those products that do have discount' do
        expect(order.gross_total).to eq expected_gross_w_discount
      end
    end

    context 'when no products of an order are inside a price list' do
      let(:products) { [product_3] }

      it 'should only use default price of products' do
        expect(order.gross_total).to eq product_3.gross_price
      end
    end

    context 'when products are inside price list but belong to different company' do
      let(:company2)               { create(:company) }
      let(:order)                 { create(:order, company: company2) }
      let(:products)              { [product_1, product_2, product_3] }
      let(:expected_simple_gross) { 1300 } # p1 + p2 + p3

      it 'should not use a price list that doesnt belong to the company making the order' do
        expect(order.gross_total).to eq expected_simple_gross
      end
    end

    context 'when there are multiple price_lists that apply for same product' do
      let(:price_list2)   { create(:price_list, company: company) }
      let!(:discount_1_1) { create(:discount, cents: 1, product: product_1, price_list: price_list2) }
      let(:products)      { [product_1, product_2] }
      let(:expected_gross_w_discount) { 75 } # (p1 - d1_1) + (p2 - d2)

      before do
        Timecop.travel(price_list.created_at + 2.days)
        discount_1_1.update!(cents: 75)
      end

      it 'uses the newest discount for products' do
        expect(order.gross_total).to eq expected_gross_w_discount
      end
    end
  end
end
