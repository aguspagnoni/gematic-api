class BillingInfosController < ApplicationController
  before_action :set_billing_info, only: [:show, :update, :destroy]

  # GET /billing_infos
  def index
    @billing_infos = BillingInfo.all

    render json: @billing_infos
  end

  # GET /billing_infos/1
  def show
    render json: @billing_info
  end

  # POST /billing_infos
  def create
    @billing_info = BillingInfo.new(billing_info_params)

    if @billing_info.save
      render json: @billing_info, status: :created, location: @billing_info
    else
      render json: @billing_info.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /billing_infos/1
  def update
    if @billing_info.update(billing_info_params)
      render json: @billing_info
    else
      render json: @billing_info.errors, status: :unprocessable_entity
    end
  end

  # DELETE /billing_infos/1
  def destroy
    @billing_info.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_billing_info
    @billing_info = BillingInfo.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def billing_info_params
    params.require(:billing_info).permit(:address, :cuit, :condition, :razon_social)
  end
end
