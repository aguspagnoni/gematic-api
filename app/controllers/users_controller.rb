class UsersController < ApplicationController
  include Registration
  ADMIN_AUTHENTICATED = [:index, :destroy]
  UNAUTHENTICATED     = [:create, :confirm]
  before_action :authenticate_admin_user, only: ADMIN_AUTHENTICATED
  before_action :authenticate_user, except: UNAUTHENTICATED + ADMIN_AUTHENTICATED
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      send_confirmation_mail(@user)
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # POST /confirm
  def confirm
    @user = user_from(user_params[:email], user_params[:token])
    if @user
      @user.confirmed!
      render 'Welcome!'
    else
      head :not_found
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:address, :email, :family_name, :name, :phone_number, :cellphone,
                                 :password, :company_id, :token)
  end
end
