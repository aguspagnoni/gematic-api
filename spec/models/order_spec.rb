require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should have_and_belong_to_many :products }
  it { should belong_to :client }

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
    let(:price_list)      { create(:price_list_with_products) }
    let(:order)           { create(:order) }
    let(:expected_gross)  { price_list.products.sum(&:gross_price) }

    before do
      order.products << price_list.products
    end

    it { expect(order.gross_total).not_to eq expected_gross }

    pending 'add quantity per product and calculate discounted gross'

  end
end
