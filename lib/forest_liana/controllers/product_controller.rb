if ForestLiana::UserSpace.const_defined?('ProductController')
  ForestLiana::UserSpace::ProductController.class_eval do
    def update
      whodunnit = forest_user["data"]["data"]["email"]
      PaperTrail.whodunnit = whodunnit
      if cost_changed? && !supervisor?(whodunnit)
        msg = 'Consulte a un supervisor como cambiar el costo'
        render json: ForestUtils.toast(msg), status: :unprocessable_entity
      else
        super
      end
    end

    private

    def cost_changed?
      params.fetch('data')["attributes"]["cost"].present?
    end

    def supervisor?(whodunnit)
      AdminUser.find_by(email: whodunnit)&.supervisor?
    end

    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    # def product_params
    #   permitted = params.fetch(:data, {})[:attributes].permit(PriceList::PERMITED_PARAMS)
    #   relationships = params.fetch(:data).fetch(:relationships)
    #   permitted[:admin_user_id] = relationships[:admin_user][:data][:id]
    #   permitted[:company_id] = relationships[:company][:data][:id]
    #   permitted
    # end
  end
end
