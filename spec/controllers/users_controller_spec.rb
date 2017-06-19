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

RSpec.describe UsersController, type: :controller do
  let(:user_example) { build(:user) }
  # This should return the minimal set of attributes required to create a valid
  # user. As you add validations to user, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { email: user_example.email, password: user_example.password, company_id: user_example.company.id }
  end

  let(:invalid_attributes) do
    { email: 'not_an_email' }
  end

  let(:invalid_attributes_errors) do
    %w(company email password)
  end

  let(:no_session) { {} }
  let(:valid_admin_session) { {} }

  describe "GET #index" do
    it "assigns all users as @users" do
      user = User.create! valid_attributes
      skip('needs admin logic!')
      get :index, params: {}
      expect(assigns(:users)).to eq([user])
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user = User.create! valid_attributes
      skip('needs admin logic!')
      expect {
        delete :destroy, params: { id: user.to_param }
      }.to change(user, :count).by(-1)
    end

    it "redirects to the users list" do
      user = User.create! valid_attributes
      skip('needs admin logic!')
      delete :destroy, params: { id: user.to_param }
      expect(response).to redirect_to(users_url)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new user" do
        skip('think this case with confirmation link')
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
        # FIXME: skip('add email confirmation logic..')
      end

      it "assigns a newly created user as @user" do
        # FIXME: skip('think this case with confirmation link')
        skip('think this case with confirmation link')
        post :create, params: { user: valid_attributes }
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "redirects to a confirmation link" do
        # FIXME: expect email to have been sent
        skip('think this case with confirmation link')
        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status :created
        expect(json_response['id']).to eq(User.last.id)
      end
    end

    context "with invalid params" do
      skip('think this case with confirmation link')
      it "specifies invalid attributes errors" do
        post :create, params: { user: invalid_attributes }
        expect(json_response.keys).to match invalid_attributes_errors
      end
    end
  end

  describe 'user authenticated' do
    let(:user) { User.create! valid_attributes }
    before do
      add_authentication_header_for(user.id)
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          { name: 'new name' }
        }

        it "updates the requested user" do
          put :update, params: { id: user.to_param, user: new_attributes }
          user.reload
          expect(user.name).to eq new_attributes[:name]
        end

        it "assigns the requested user as @user" do
          put :update, params: { id: user.to_param, user: new_attributes }
          expect(assigns(:user)).to eq(user)
        end
      end

      context "with invalid params" do
        it "assigns the user as @user" do
          put :update, params: { id: user.to_param, user: invalid_attributes }
          expect(assigns(:user)).to eq(user)
        end
      end
    end

    describe "GET #show" do
      it "assigns the requested user as @user" do
        get :show, params: { id: user.to_param }
        expect(assigns(:user)).to eq(user)
      end
    end
  end
end