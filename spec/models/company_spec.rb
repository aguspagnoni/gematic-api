require 'rails_helper'

RSpec.describe Company, type: :model do
  it { should have_many :billing_info }
  it { should have_many :orders }
  it { should have_many :users }
  it { should have_many :branch_offices }
end
