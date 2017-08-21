require 'rails_helper'

RSpec.describe Discount, type: :model do
  let!(:company)   { create(:company) }
  let(:cost)       { 100 }
  let(:product)    { create(:product, cost: cost) }
  let(:price_list) { create(:price_list, company: company) }

  context 'fixed discount' do
    let!(:fixed_discount) do
      create(:discount, price_list: price_list, product: product, fixed: true)
    end
    # Note the ! that makes it run before the update
    let!(:fixed_price) { product.standard_price - fixed_discount.cents }

    it 'uses gross price frozen at creation time' do
      expect { product.update(cost: product.cost + 1) }
        .not_to change(fixed_discount, :apply)
      expect(fixed_discount.apply).to eq fixed_price
    end

    it 'varies only if discount cents itself change' do
      expect { fixed_discount.update(cents: fixed_discount.cents + 1) }
        .to change(fixed_discount, :apply)
    end
  end

  context 'dynamic discount' do
    let!(:dynamic_discount) do
      create(:discount, price_list: price_list, product: product)
    end
    # Note this will be run after update
    let(:final_price) { product.standard_price - dynamic_discount.cents }

    it 'uses gross price when requested' do
      expect { product.update(cost: product.cost + 1) }
        .to change(dynamic_discount, :apply)
      expect(dynamic_discount.apply).to eq final_price
    end
  end

  describe '#for_company_and_product' do
    let!(:company2)    { create(:company) }
    let!(:price_list)  { create(:price_list_with_products, company: company) }
    let!(:price_list2) { create(:price_list_with_products, company: company2) }
    let(:product)      { price_list.products.first }

    it 'selects those discounts that belong to the company and not others' do
      discount = Discount.for_company_and_product(company, product)
      expect(discount.product).to eq product
      expect(discount.company).to eq company
    end
  end

  context 'when discount is bigger than producs cost' do
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
