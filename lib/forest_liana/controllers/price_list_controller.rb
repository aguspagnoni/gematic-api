if ForestLiana::UserSpace.const_defined?('PriceListController')
  ForestLiana::UserSpace::PriceListController.class_eval do
    def update
      set_price_list
      PaperTrail.whodunnit = forest_user["data"]["data"]["email"]
      @price_list.update(price_list_params)
      if @price_list.valid?
        render json: @price_list
      else
        render json: @price_list.errors.messages, status: :unprocessable_entity
      end
    end

    def destroy
      # TODO: validate if is admin?
    end

    private

    def set_price_list
      @price_list = PriceList.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def price_list_params
      permitted = params.fetch(:data, {})[:attributes].permit(PriceList::PERMITED_PARAMS)
      relationships = params.fetch(:data).fetch(:relationships)
      permitted[:admin_user_id] = relationships[:admin_user][:data][:id]
      permitted[:company_id] = relationships[:company][:data][:id]
      permitted
    end
  end
end
