require 'rails_helper'

RSpec.describe Category, type: :model do
  let!(:category_a) { create(:category, name: 'A') }
  let!(:category_b) { create(:category, supercategory: category_a, name: 'B') }
  let!(:category_c) { create(:category, supercategory: category_b, name: 'C') }
  let!(:category_d) { create(:category, supercategory: category_b, name: 'D') }
  let!(:category_e) { create(:category, supercategory: category_c, name: 'E') }
  let!(:category_f) { create(:category, name: 'F') }

  let(:expected_tree) do
    {
      'A' => {
        'B' => {
          'C' => {
            'E' => nil
          },
          'D' => nil
        }
      },
      'F' => nil
    }
  end

  it { expect(category_b.supercategory).to eq category_a }
  it { expect(described_class.root).to match_array [category_a, category_f] }
  it { expect(described_class.tree).to match expected_tree }

  context 'when by mistake someone use same category for supercategory' do
    it 'validates non recursive categories' do
      expect { category_a.update!(supercategory: category_a) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
