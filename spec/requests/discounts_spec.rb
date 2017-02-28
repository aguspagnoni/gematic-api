require 'rails_helper'

RSpec.describe "Discounts", type: :request do
  describe "GET /discounts" do
    it "works! (now write some real specs)" do
      get discounts_path
      expect(response).to have_http_status(200)
    end
  end
end
