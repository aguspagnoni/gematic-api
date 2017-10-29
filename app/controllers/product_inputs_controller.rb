class ProductInputsController < ApplicationController
  before_action :set_product_input, only: [:show, :update, :destroy]

  # GET /product_inputs
  def index
    @product_inputs = ProductInput.all

    render json: @product_inputs
  end

  # GET /product_inputs/1
  def show
    render json: @product_input
  end

  # POST /product_inputs
  def create
    @product_input = ProductInput.new(product_input_params)

    if @product_input.save
      render json: @product_input, status: :created, location: @product_input
    else
      render json: @product_input.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /product_inputs/1
  def update
    if @product_input.update(product_input_params)
      render json: @product_input
    else
      render json: @product_input.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_inputs/1
  def destroy
    @product_input.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_input
      @product_input = ProductInput.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_input_params
      params.fetch(:product_input, {})
    end
end
