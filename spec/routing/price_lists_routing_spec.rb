require "rails_helper"

RSpec.describe PriceListsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/price_lists").to route_to("price_lists#index")
    end

    it "routes to #new" do
      expect(:get => "/price_lists/new").to route_to("price_lists#new")
    end

    it "routes to #show" do
      expect(:get => "/price_lists/1").to route_to("price_lists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/price_lists/1/edit").to route_to("price_lists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/price_lists").to route_to("price_lists#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/price_lists/1").to route_to("price_lists#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/price_lists/1").to route_to("price_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/price_lists/1").to route_to("price_lists#destroy", :id => "1")
    end

  end
end
