if ForestLiana::UserSpace.const_defined?('DiscountController')
  ForestLiana::UserSpace::DiscountController.class_eval do

    NEED_SUPERADMIN = 'Para cambiar las condiciones de un descuento pactado, '\
                      'pregunte al administrador'.freeze

    def update
      set_discount
      PaperTrail.whodunnit = whodunnit
      if action_needs_authorization
        render json: ForestUtils.toast(NEED_SUPERADMIN), status: :bad_request
      else
        super
      end
    end

    private

    def set_discount
      @discount = Discount.find(params[:id])
    end

    def whodunnit
      forest_user["data"]["data"]["email"]
    end

    def action_needs_authorization
      fixed_changed = params.fetch('data')['attributes'].keys.include? 'fixed'
      @discount.fixed && fixed_changed && !superadmin?
    end

    def superadmin?
      user = AdminUser.find_by(email: whodunnit)
      user&.superadmin?
    end
  end
end
