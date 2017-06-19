require 'rails_helper'

RSpec.describe BillingInfo, type: :model do
  it { should belong_to :company }
end
