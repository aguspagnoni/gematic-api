if ForestLiana::UserSpace.const_defined?('PriceListController')
  ForestLiana::UserSpace::PriceListController.class_eval do
    def update
      set_price_list
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
