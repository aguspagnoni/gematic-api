class CatgoriesController < ApplicationController
  before_action :set_catgory, only: [:show, :update, :destroy]

  # GET /catgories
  def index
    @catgories = Catgory.all

    render json: @catgories
  end

  # GET /catgories/1
  def show
    render json: @catgory
  end

  # POST /catgories
  def create
    @catgory = Catgory.new(catgory_params)

    if @catgory.save
      render json: @catgory, status: :created, location: @catgory
    else
      render json: @catgory.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /catgories/1
  def update
    if @catgory.update(catgory_params)
      render json: @catgory
    else
      render json: @catgory.errors, status: :unprocessable_entity
    end
  end

  # DELETE /catgories/1
  def destroy
    @catgory.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catgory
      @catgory = Catgory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def catgory_params
      params.require(:catgory).permit(:name)
    end
end
