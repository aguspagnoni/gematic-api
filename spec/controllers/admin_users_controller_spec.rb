require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe AdminUsersController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # AdminUser. As you add validations to AdminUser, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip("Add a hash of attributes valid for your model")
  end

  let(:invalid_attributes) do
    skip("Add a hash of attributes invalid for your model")
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AdminUsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all admin_users as @admin_users" do
      admin_user = AdminUser.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:admin_users)).to eq([admin_user])
    end
  end

  describe "GET #show" do
    it "assigns the requested admin_user as @admin_user" do
      admin_user = AdminUser.create! valid_attributes
      get :show, params: { id: admin_user.to_param }, session: valid_session
      expect(assigns(:admin_user)).to eq(admin_user)
    end
  end

  describe "GET #edit" do
    it "assigns the requested admin_user as @admin_user" do
      admin_user = AdminUser.create! valid_attributes
      get :edit, params: { id: admin_user.to_param }, session: valid_session
      expect(assigns(:admin_user)).to eq(admin_user)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new AdminUser" do
        expect {
          post :create, params: { admin_user: valid_attributes }, session: valid_session
        }.to change(AdminUser, :count).by(1)
      end

      it "assigns a newly created admin_user as @admin_user" do
        post :create, params: { admin_user: valid_attributes }, session: valid_session
        expect(assigns(:admin_user)).to be_a(AdminUser)
        expect(assigns(:admin_user)).to be_persisted
      end

      it "redirects to the created admin_user" do
        post :create, params: { admin_user: valid_attributes }, session: valid_session
        expect(response).to redirect_to(AdminUser.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved admin_user as @admin_user" do
        post :create, params: { admin_user: invalid_attributes }, session: valid_session
        expect(assigns(:admin_user)).to be_a_new(AdminUser)
      end

      it "re-renders the 'new' template" do
        post :create, params: { admin_user: invalid_attributes }, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested admin_user" do
        admin_user = AdminUser.create! valid_attributes
        put :update, params: { id: admin_user.to_param, admin_user: new_attributes }, session: valid_session
        admin_user.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested admin_user as @admin_user" do
        admin_user = AdminUser.create! valid_attributes
        put :update, params: { id: admin_user.to_param, admin_user: valid_attributes }, session: valid_session
        expect(assigns(:admin_user)).to eq(admin_user)
      end

      it "redirects to the admin_user" do
        admin_user = AdminUser.create! valid_attributes
        put :update, params: { id: admin_user.to_param, admin_user: valid_attributes }, session: valid_session
        expect(response).to redirect_to(admin_user)
      end
    end

    context "with invalid params" do
      it "assigns the admin_user as @admin_user" do
        admin_user = AdminUser.create! valid_attributes
        put :update, params: { id: admin_user.to_param, admin_user: invalid_attributes }, session: valid_session
        expect(assigns(:admin_user)).to eq(admin_user)
      end

      it "re-renders the 'edit' template" do
        admin_user = AdminUser.create! valid_attributes
        put :update, params: { id: admin_user.to_param, admin_user: invalid_attributes }, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested admin_user" do
      admin_user = AdminUser.create! valid_attributes
      expect {
        delete :destroy, params: { id: admin_user.to_param }, session: valid_session
      }.to change(AdminUser, :count).by(-1)
    end

    it "redirects to the admin_users list" do
      admin_user = AdminUser.create! valid_attributes
      delete :destroy, params: { id: admin_user.to_param }, session: valid_session
      expect(response).to redirect_to(admin_users_url)
    end
  end
end
