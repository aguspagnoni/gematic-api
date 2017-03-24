require 'rails_helper'

RSpec.describe Category, type: :model do
  let!(:category_a) { create(:category) }
  let(:category_b) { create(:category, subcategory: category_a) }

  it { expect(category_b.subcategory).to eq category_a }

  context 'when by mistake someone use same category for subcategory' do
    it 'validates non recursive categories' do
      expect { category_a.update!(subcategory: category_a) }.to raise_error(ActiveRecord::RecordNotSaved)
    end
  end
end
