require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should have_many :products }
  it { should belong_to :branch_office }
  it { should belong_to :billing_info }

  let(:company)     { create(:company) }
  let(:office)      { create(:branch_office, company: company) }
  let(:billing)     { create(:billing_info, company: company) }

  context 'branch_office.company != order.company' do
    let(:company2)     { create(:company) }
    let(:office2)      { create(:branch_office, company: company2) }
    let(:build_order) do
      build(:order, company: company, branch_office: office2, billing_info: billing)
    end

    it 'should raise error if branch office doesnt belong to the company selected' do
      invalid = build_order
      expect(invalid.valid?).to be false
      expect(invalid.errors.messages[:branch_office]).not_to be_empty
    end
  end

  context 'billing_info.company != order.company' do
    let(:company2)     { create(:company) }
    let(:billing2)     { create(:billing_info, company: company2) }
    let(:build_order) do
      build(:order, company: company, branch_office: office, billing_info: billing2)
    end

    it 'should raise error if branch office doesnt belong to the company selected' do
      invalid = build_order
      expect(invalid.valid?).to be false
      expect(invalid.errors.messages[:billing_info]).not_to be_empty
    end
  end

  context 'status' do
    let(:order) { create(:order, status: :not_confirmed, company: company,
                                 branch_office: office, billing_info: billing) }

    it 'does not allow any status as valid' do
      expect { build(:order, status: 999) }.to raise_error(ArgumentError)
    end

    it 'changes status accordingly' do
      expect { order.confirmed! }.to change(order, :status).from('not_confirmed').to('confirmed')
    end
  end

  context 'when calculating totals' do
    let(:price_list)  { create(:price_list, company: company) }
    let(:product_1)   { create(:product, cost: 100 / Product::COST_MULTIPLIER) }
    let(:product_2)   { create(:product, cost: 200 / Product::COST_MULTIPLIER) }
    let(:product_3)   { create(:product, cost: 1000 / Product::COST_MULTIPLIER) }
    let!(:discount_1) { create(:discount, cents: 5, product: product_1, price_list: price_list) }
    let!(:discount_2) { create(:discount, cents: 15, product: product_2, price_list: price_list) }
    let(:order)       { create(:order, company: price_list.company, branch_office: office,
                                       billing_info: billing) }
    let(:products)    { [product_1, product_2] }

    before do
      products.map do |product|
        create(:order_item, product: product, order: order, quantity: 1)
      end
    end

    context 'when all products of an order is inside a price list' do
      let(:expected_simple_gross)     { 300 } # p1 + p2
      let(:expected_gross_w_discount) { 280 } # (p1 - d1) + (p2 - d2)

      it 'should not use the default prices' do
        expect(order.gross_total).not_to eq expected_simple_gross
      end

      it 'should use every discount for the products that are inside the price list' do
        expect(order.gross_total).to eq expected_gross_w_discount
      end
    end

    context 'when some products of an order are inside a price list' do
      let(:expected_gross_w_discount) { 1280 } # (p1 - d1) + (p2 - d2) + p3
      let(:products) { [product_1, product_2, product_3] }

      it 'should use discounts for those products that do have discount' do
        expect(order.gross_total).to eq expected_gross_w_discount
      end
    end

    context 'when no products of an order are inside a price list' do
      let(:products) { [product_3] }

      it 'should only use default price of products' do
        expect(order.gross_total).to eq product_3.standard_price
      end
    end

    context 'when products are inside price list but belong to different company' do
      let(:company2)              { create(:company) }
      let(:office2)               { create(:branch_office, company: company2) }
      let(:billing2)              { create(:billing_info, company: company2) }
      let(:order)                 { create(:order, company: company2, branch_office: office2,
                                                   billing_info: billing2) }
      let(:products)              { [product_1, product_2, product_3] }
      let(:expected_simple_gross) { 1300 } # p1 + p2 + p3

      it 'should not use a price list that doesnt belong to the company making the order' do
        expect(order.gross_total).to eq expected_simple_gross
      end
    end
  end
end
