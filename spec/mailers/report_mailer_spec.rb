require 'rails_helper'

RSpec.describe ReportMailer, type: :mailer do
  let(:body)              { mail.attachments.first.body }
  let(:budget_image_name) { 'borrador.png' }

  describe 'pricelist_summary' do
    let(:pricelist)  { create(:price_list_with_company_and_products) }
    let(:admin_user) { create(:admin_user) }
    let(:mail) { ReportMailer.pricelist_summary(pricelist, admin_user) }

    it 'renders the html ok' do
      expect(body).to include(pricelist.discounts.first.product.name)
    end
  end

  describe 'order_summary' do
    let(:pricelist)  { create(:price_list_with_company_and_products) }
    let(:admin_user) { create(:admin_user) }
    let(:order)      { create(:order, status: :confirmed) }
    let(:mail) { ReportMailer.order_summary(order, admin_user) }

    context 'when the order is <<not_confirmed>>' do
      let(:order) { create(:order, status: :not_confirmed) }
      it 'renders the html with a special text' do
        # write_file_and_open(body)
        expect(body).to include(budget_image_name)
      end
    end

    context 'when the order is <<with_invoice>>' do
      let(:order) { create(:order, status: :with_invoice) }
      it 'renders the html' do
        expect(body).not_to include(budget_image_name)
      end
    end

    it 'renders the html' do
      expect(body).not_to include(budget_image_name)
    end
  end
end

def write_file_and_open(content)
  filename = 'tmp/mail_content_spec.html'
  f = File.new(filename, 'w')
  f.write(content)
  f.close
  `open #{filename}`
end
