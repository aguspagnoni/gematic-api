require 'rails_helper'

RSpec.describe Company, type: :model do
  it { should have_many :orders }
  it { should have_many :users }
  it { should have_many :branch_offices }

  describe '#similar_company_validation' do
    context 'when no previous similar company exists' do
      let(:new_company)       { create(:company, razon_social: 'nueva s.a') }

      it 'creates it normally' do
        expect(new_company).to be_valid
      end
    end

    context 'when similar razon_social exists' do
      let!(:existing_company) { create(:company, razon_social: 'ejemplo S.a') }
      let(:new_company)       { build(:company, razon_social: 'EJEMPLO S.A.') }

      it 'adds razon_social error' do
        expect(new_company).not_to be_valid
      end
    end

    context 'when similar cuit exists' do
      let!(:existing_company) { create(:company, cuit: '30-11222333-1') }
      let(:new_company)       { build(:company, cuit: '30-112223331') }


      it 'adds razon_social error' do
        expect(new_company).not_to be_valid
      end
    end
  end
end
