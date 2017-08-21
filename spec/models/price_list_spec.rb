require 'rails_helper'

RSpec.describe PriceList, type: :model do
  let(:company)             { create(:company) }
  let(:gross_price)         { 1000 }
  let!(:product_w_discount) { create(:product, gross_price: gross_price) }
  let!(:default_product)    { create(:product, gross_price: gross_price) }
  let!(:price_list)         { create(:price_list, company: company) }

  let!(:discount)           { create(:discount, price_list: price_list, product: product_w_discount) }
  let(:list_details)        { { product: product_w_discount, discount: discount } }

  it { expect(product_w_discount.gross_price).to eq gross_price }
  it { expect(price_list.products).to include product_w_discount }
  it { expect(price_list.products).not_to include default_product }
  it 'has details of those products that a discount is applied' do
    expect(price_list.details).to match_array(a_hash_including(list_details))
  end

  describe 'active scope' do
    before do
      Timecop.freeze('2017-08-21')
    end
    let!(:price_list) do
      create(:price_list, company: company, expires: Date.tomorrow, valid_since: Date.yesterday)
    end
    let!(:price_list_err) do
      create(:price_list, company: company,
             expires: Date.yesterday, valid_since: Date.yesterday - 1.day)
    end

    it 'filters those that are outside the scope' do
      expect(PriceList.active).to match_array([price_list])
    end
  end

  describe 'General Discounts' do
    let(:general_discount) { 10.0 }
    let(:disc_multiplier)  { 0.9 } # 90%
    let(:product_discount) { 2.0 }
    let(:price_list_10)    { create(:price_list, company: company, general_discount: general_discount) }
    let(:price_list)       { create(:price_list, company: company) }
    let(:product)          { create(:product, cost: 100) }
    let(:price_after_general_disc) { product.standard_price * disc_multiplier }

    it 'validates general discount between 0 and 100' do
      expect { create(:price_list, company: company, general_discount: -10.0) }
        .to raise_error(ActiveRecord::RecordInvalid)
      expect { create(:price_list, company: company, general_discount: 100.1) }
        .to raise_error(ActiveRecord::RecordInvalid)
      expect { create(:price_list, company: company, general_discount: 50.0) }
        .not_to raise_error
    end

    context 'SIN desc_particular SIN desc_general' do
      it 'doesnt affect standard price' do
        expect(product.price_within(price_list)).to eq(product.standard_price)
      end
    end

    context 'SIN desc_particular CON desc_general' do
      it 'applies general discount' do
        expect(product.price_within(price_list_10)).to eq price_after_general_disc
      end
    end

    context 'CON desc_particular SIN desc_general' do
      let(:discount) { create(:discount, price_list: price_list, product: product) }

      it 'should apply general discount and then desc_particular' do
        expect(product.price_within(price_list)).to eq(product.standard_price - discount.cents)
      end
    end

    context 'CON desc_particular CON desc_general' do
      let(:discount) { create(:discount, price_list: price_list_10, product: product) }

      it 'should apply general discount and then desc_particular' do
        expect(product.price_within(price_list_10))
          .to eq(price_after_general_disc - discount.cents)
      end

      context 'when Discount is fixed' do
        let(:fixed_discount) do
          create(:discount, price_list: price_list_10, product: product, fixed: true)
        end

        it 'should not change the final price after updating cost' do
          expect { fixed_discount.update(cents: fixed_discount.cents + 1) }
            .not_to change(fixed_discount, :apply)
        end
      end
    end
  end

  describe '#discount_multiplier' do
    let(:price_list) { create(:price_list, company: company, general_discount: 12.5) }

    it { expect(price_list.discount_multiplier).to eq(0.875) }
  end

  describe 'authorizing a PriceList' do
    let(:authorizer)      { create(:admin_user, privilege: :supervisor) }
    let(:bad_authorizer)  { create(:admin_user, privilege: :back_office) }

    it 'fails if authorizer is the same person as the one who created it' do
      expect { price_list.authorize!(price_list.admin_user) }.to raise_error(ActiveRecord::RecordNotSaved)
    end

    it 'fails if authorizer does not have the correct privilege' do
      expect { price_list.authorize!(bad_authorizer) }.to raise_error(ActiveRecord::RecordNotSaved)
    end

    it 'saves the time of authorization if authorizer is someone else' do
      expect { price_list.authorize!(authorizer) }
        .to change(price_list, :authorized_at)
        .and change(price_list, :authorizer).to(authorizer)
    end
  end

  describe 'validity dates' do
    let(:valid_since)      { Date.new(2017, 1, 1) }
    let(:valid_expires)    { valid_since + 1.day }
    let(:invalid_expires)  { valid_since }
    let(:invalid_msg)      { I18n.t 'errors.messages.expires_validation' }

    it 'allows greater than valid_since dates for expire' do
      price_list = create(:price_list_with_company, valid_since: valid_since, expires: valid_expires)
      expect(price_list).to be_valid
    end

    it 'doesnt allow invalid dates' do
      invalid = build(:price_list_with_company, valid_since: valid_since, expires: invalid_expires)
      expect(invalid.valid?).to be false
      expect(invalid.errors.messages[:expires].first).to eq invalid_msg
    end
  end
end
