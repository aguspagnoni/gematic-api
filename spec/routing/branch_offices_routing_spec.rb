require "rails_helper"

RSpec.describe BranchOfficesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/branch_offices").to route_to("branch_offices#index")
    end

    it "routes to #show" do
      expect(:get => "/branch_offices/1").to route_to("branch_offices#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/branch_offices").to route_to("branch_offices#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/branch_offices/1").to route_to("branch_offices#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/branch_offices/1").to route_to("branch_offices#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/branch_offices/1").to route_to("branch_offices#destroy", :id => "1")
    end

  end
end
