class BranchOfficesController < ApplicationController
  before_action :set_branch_office, only: [:show, :update, :destroy]

  # GET /branch_offices
  def index
    @branch_offices = BranchOffice.all

    render json: @branch_offices
  end

  # GET /branch_offices/1
  def show
    render json: @branch_office
  end

  # POST /branch_offices
  def create
    @branch_office = BranchOffice.new(branch_office_params)

    if @branch_office.save
      render json: @branch_office, status: :created, location: @branch_office
    else
      render json: @branch_office.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /branch_offices/1
  def update
    if @branch_office.update(branch_office_params)
      render json: @branch_office
    else
      render json: @branch_office.errors, status: :unprocessable_entity
    end
  end

  # DELETE /branch_offices/1
  def destroy
    @branch_office.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_branch_office
      @branch_office = BranchOffice.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def branch_office_params
      params.require(:branch_office).permit(:references, :name, :address, :zipcode, :geolocation)
    end
end
