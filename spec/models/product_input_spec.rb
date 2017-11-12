require 'rails_helper'

RSpec.describe ProductInput, type: :model do
  it { should validate_presence_of :buyer_company}
  it { should validate_presence_of :seller_company}
  it { should validate_presence_of :admin_user}
  it { should validate_presence_of :product}
  it { should validate_presence_of :reference_number}
  it { should validate_presence_of :unit_price}
  it { should validate_presence_of :quantity}
  it { should validate_numericality_of(:quantity).is_greater_than 0 }

  context 'when creating/building a ProductInput' do
    context 'happy path' do
      let(:product)               { create(:product) }
      let(:new_stock)             { 1 }
      let(:product_input)  { create(:product_input, product: product, quantity: new_stock) }

      it 'updates product stock after create' do
        expect { product_input }.to change(product, :stock).by(new_stock)
      end

      it 'must have a valid buyer' do
        razon_social = product_input.buyer_company.razon_social
        expect(ProductInput::VALID_BUYERS).to include(razon_social)
      end
    end

    context 'buyer and seller are the same' do
      let(:company) { create(:company) }
      let(:error_msg)  { I18n.t 'errors.messages.product_input_same_company' }

      subject { build(:product_input, buyer_company: company, seller_company: company) }

      it 'cant have both buyer and seller companies be the same' do
        expect(subject.valid?).to be false
        expect(subject.errors.messages[:seller_company].first).to eq error_msg
      end
    end

    context 'with already registered inputs' do
      let(:error_msg)         { I18n.t 'errors.messages.product_input_already_registered' }
      let(:company_1)         { create(:company) }
      let(:company_2)         { create(:company) }
      let(:reference_number)  { '1' }

      subject { build(:product_input, reference_number: reference_number, seller_company: company_1) }

      before do
        create(:product_input, reference_number: reference_number, seller_company: company_1)
      end

      it 'validates the same reference number not be created twice for the same Provider' do
        expect(subject.save).to be false
        expect(subject.errors.messages[:seller_company].first).to eq error_msg
      end

      it 'accepts same reference number from different companies' do
        subject2 = build(:product_input, reference_number: reference_number, seller_company: company_2)
        expect(subject2.valid?).to be true
      end
    end

    context 'with invalid buyer company' do
      let(:error_msg)      { I18n.t 'errors.messages.incorrect_buyer_company' }
      let(:product)        { create(:product) }
      let(:buyer_company)  { create(:company, razon_social: 'test') }
      let(:new_stock)      { 1 }
      let(:product_input)  { build(:product_input, buyer_company: buyer_company,
                                                    product: product, quantity: new_stock) }

      it 'remarks invalid buyer' do
        expect(product_input.valid?).to be false
        expect(product_input.errors.messages[:buyer_company].first).to eq error_msg
      end
    end
  end
end
