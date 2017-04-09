require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should have_and_belong_to_many :categories }
end
