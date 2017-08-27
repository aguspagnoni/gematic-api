if ForestLiana::UserSpace.const_defined?('PriceListController')
  ForestLiana::UserSpace::PriceListController.class_eval do

    NEED_SUPERADMIN = 'Para cambiar las condiciones de una lista de precios pactada,'\
                      'pregunte al administrador'.freeze

    def update
      set_price_list
      PaperTrail.whodunnit = whodunnit
      if action_needs_authorization
        render json: ForestUtils.toast(NEED_SUPERADMIN), status: :bad_request
      else
        @price_list.update(price_list_params)
        if @price_list.valid?
          render json: @price_list
        else
          render json: @price_list.errors.messages, status: :unprocessable_entity
        end
      end
    end

    def destroy
      # TODO: validate if is admin?
    end

    private

    def set_price_list
      @price_list = PriceList.find(params[:id])
    end

    def whodunnit
      forest_user["data"]["data"]["email"]
    end

    def action_needs_authorization
      general_discount_changed = params.fetch('data')['attributes']['general_discount'].present?
      @price_list.authorized? && general_discount_changed && !superadmin?
    end

    def superadmin?
      user = AdminUser.find_by(email: whodunnit)
      user&.superadmin?
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
