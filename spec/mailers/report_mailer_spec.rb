require 'rails_helper'

RSpec.describe ReportMailer, type: :mailer do

  describe 'pricelist_summary' do
    let(:pricelist)  { create(:price_list_with_company_and_products) }
    let(:admin_user) { create(:admin_user) }
    let(:mail) { ReportMailer.pricelist_summary(pricelist, admin_user) }

    it 'renders the html ok' do
      expect(mail.body).to include(pricelist.discounts.first.product.name)
    end
  end
end
