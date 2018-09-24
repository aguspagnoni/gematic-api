require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should have_many :products }
  it { should belong_to :branch_office }

  let(:company)     { create(:company) }
  let(:office)      { create(:branch_office, company: company) }

  context 'branch_office.company != order.company' do
    let(:company2)     { create(:company) }
    let(:office2)      { create(:branch_office, company: company2) }
    let(:build_order) do
      build(:order, company: company, branch_office: office2)
    end

    it 'should raise error if branch office doesnt belong to the company selected' do
      invalid = build_order
      expect(invalid.valid?).to be false
      expect(invalid.errors.messages[:branch_office]).not_to be_empty
    end
  end

  context 'status' do
    let(:order) {
      create(:order, status: :presupuesto, company: company,
                     branch_office: office)
    }

    it 'does not allow any status as valid' do
      expect { build(:order, status: 999) }.to raise_error(ArgumentError)
    end

    it 'changes status accordingly' do
      expect { order.confirmado! }.to change(order, :status).from('presupuesto').to('confirmado')
    end

    context 'stock of a product after change of state' do
      let(:product)        { create(:product) }
      let(:product2)       { create(:product) }
      let(:amount_ordered) { 1 }
      let(:create_order) do
        create(:order_item, product: product, order: order, quantity: amount_ordered)
      end
      let(:create_order2) do
        create(:order_item, product: product2, order: order, quantity: amount_ordered)
      end

      context 'creating an UNCONFIRMED order' do
        it 'does not alter product stock' do
          expect {
            create_order
            product.reload
          }.not_to change(product, :stock)
        end
      end

      context 'order status UNCONFIRMED -> CONFIRMED' do
        before do
          create_order
          create_order2
        end

        it 'alter product stock' do
          expect do
            order.confirmado!
            product.reload
            product2.reload
          end.to change(product, :stock).by(-amount_ordered)
            .and change(product2, :stock).by(-amount_ordered)
        end
      end

      context 'order status DEFAULT -> CONFIRMED -> ANULATED' do
        before do
          create_order
          create_order2
          order.confirmado!
        end

        it 'leaves product stock as it was in the first place' do
          expect do
            order.anulado!
            product.reload
            product2.reload
          end.to change(product, :stock).by(0)
            .and change(product2, :stock).by(0)
        end
      end

      context 'order status DEFAULT -> CONFIRMED -> WITH_INVOICE -> ANULATED' do
        before do
          create_order
          create_order2
          order.confirmado!
          order.con_factura!
        end

        it 'leaves product stock as it was in the first place' do
          expect do
            order.anulado!
            product.reload
            product2.reload
          end.to change(product, :stock).by(0)
            .and change(product2, :stock).by(0)
        end
      end

      context 'order status NOT_CONFIRMED -> WITH_INVOICE' do
        before do
          create_order
        end

        it 'throws error, as it has to first pass through confirmed state' do
          expect { order.con_factura! }.to raise_error
        end
      end

      context 'order status CONFIRMED -> WITH_INVOICE' do
        before do
          create_order
          order.confirmado!
        end

        it 'does not alter product stock' do
          expect { order.con_factura! }
            .not_to change(product.reload, :stock)
        end
      end
    end
  end

  context 'when calculating totals' do
    let(:price_list)  { create(:price_list, company: company) }
    let(:product_1)   { create(:product, cost: 100 / Product::COST_MULTIPLIER) }
    let(:product_2)   { create(:product, cost: 200 / Product::COST_MULTIPLIER) }
    let(:product_3)   { create(:product, cost: 1000 / Product::COST_MULTIPLIER) }
    let!(:discount_1) { create(:discount, cents: 5, product: product_1, price_list: price_list) }
    let!(:discount_2) { create(:discount, cents: 15, product: product_2, price_list: price_list) }
    let(:products)    { [product_1, product_2] }
    let(:order) do
      create(:order, company: price_list.company, branch_office: office)
    end

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
      let(:order)                 { create(:order, company: company2, branch_office: office2) }
      let(:products)              { [product_1, product_2, product_3] }
      let(:expected_simple_gross) { 1300 } # p1 + p2 + p3

      it 'should not use a price list that doesnt belong to the company making the order' do
        expect(order.gross_total).to eq expected_simple_gross
      end
    end
  end
end
