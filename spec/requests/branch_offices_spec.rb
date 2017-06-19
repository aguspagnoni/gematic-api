require 'rails_helper'

RSpec.describe "BranchOffices", type: :request do
  describe "GET /branch_offices" do
    it "works! (now write some real specs)" do
      get branch_offices_path
      expect(response).to have_http_status(200)
    end
  end
end
