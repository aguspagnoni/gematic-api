require 'rails_helper'

RSpec.describe "Catgories", type: :request do
  describe "GET /catgories" do
    it "works! (now write some real specs)" do
      get catgories_path
      expect(response).to have_http_status(200)
    end
  end
end
