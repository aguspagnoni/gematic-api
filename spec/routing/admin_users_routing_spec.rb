require "rails_helper"

RSpec.describe AdminUsersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin_users").to route_to("admin_users#index")
    end

    it "routes to #show" do
      expect(:get => "/admin_users/1").to route_to("admin_users#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin_users").to route_to("admin_users#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin_users/1").to route_to("admin_users#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin_users/1").to route_to("admin_users#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin_users/1").to route_to("admin_users#destroy", :id => "1")
    end

  end
end
