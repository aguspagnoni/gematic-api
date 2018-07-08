require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should belong_to :category }
  it { should have_many :orders }
  it { should have_many :order_items }
  it { should validate_numericality_of(:gross_price).is_greater_than 0 }

  let(:less_than_msg) { I18n.t 'activerecord.errors.models.product.attributes.cost.less_than' }

  it 'should have a cost smaller than the default price' do
    product = create(:product)
    product.cost = product.gross_price + 1
    expect(product.valid?).to be false
    expect(product.errors.messages[:cost].first).to include less_than_msg
  end
end
