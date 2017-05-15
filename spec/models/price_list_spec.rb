require 'rails_helper'

RSpec.describe PriceList, type: :model do
  let(:company)             { create(:company) }
  let(:gross_price)         { 100 }
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

  describe 'on update' do
    let(:new_name) { 'new name' }

    it 'leaves original list intact and creates new one with new parameters' do
      expect { price_list.update_new_copy(name: new_name) }
        .to change(PriceList, :count).by(1)
        .and not_change(price_list, :name)
      expect(PriceList.last.name).to eq new_name
    end

    it 'throws error when trying to update a list without creating new one' do
      expect { price_list.update(name: new_name) }.to raise_error(ActiveRecord::RecordNotSaved)
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
