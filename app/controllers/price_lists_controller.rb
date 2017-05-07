class PriceListsController < ApplicationController
  before_action :set_price_list, only: [:show, :update, :destroy]

  # GET /price_lists
  def index
    @price_lists = PriceList.all

    render json: @price_lists
  end

  # GET /price_lists/1
  def show
    render json: @price_list
  end

  # POST /price_lists
  def create
    @price_list = PriceList.new(price_list_params)

    if @price_list.save
      render json: @price_list, status: :created, location: @price_list
    else
      render json: @price_list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /price_lists/1
  def update
    old_price_list = @price_list
    @price_list = @price_list.update_new_copy(price_list_params)
    if @price_list.valid?
      render json: @price_list
    else
      error_message = old_price_list.errors.messages.merge(@price_list.errors.messages)
      @price_list = old_price_list
      render json: error_message, status: :unprocessable_entity
    end
  end

  # DELETE /price_lists/1
  def destroy
    @price_list.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_price_list
    @price_list = PriceList.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def price_list_params
    params.fetch(:price_list, {}).permit(PriceList::PERMITED_PARAMS)
  end
end
