require "rails_helper"

RSpec.describe CatgoriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/catgories").to route_to("catgories#index")
    end

    it "routes to #show" do
      expect(:get => "/catgories/1").to route_to("catgories#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/catgories").to route_to("catgories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/catgories/1").to route_to("catgories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/catgories/1").to route_to("catgories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/catgories/1").to route_to("catgories#destroy", :id => "1")
    end

  end
end
