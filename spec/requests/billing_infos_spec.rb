require 'rails_helper'

RSpec.describe "BillingInfos", type: :request do
  describe "GET /billing_infos" do
    it "works! (now write some real specs)" do
      get billing_infos_path
      expect(response).to have_http_status(200)
    end
  end
end
