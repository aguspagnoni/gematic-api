require 'rails_helper'

RSpec.describe "PriceLists", type: :request do
  describe "GET /price_lists" do
    it "works! (now write some real specs)" do
      get price_lists_path
      expect(response).to have_http_status(200)
    end
  end
end
