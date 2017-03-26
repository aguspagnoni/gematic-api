require "rails_helper"

RSpec.describe BillingInfosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/billing_infos").to route_to("billing_infos#index")
    end

    it "routes to #show" do
      expect(get: "/billing_infos/1").to route_to("billing_infos#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/billing_infos").to route_to("billing_infos#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/billing_infos/1").to route_to("billing_infos#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/billing_infos/1").to route_to("billing_infos#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/billing_infos/1").to route_to("billing_infos#destroy", id: "1")
    end
  end
end
