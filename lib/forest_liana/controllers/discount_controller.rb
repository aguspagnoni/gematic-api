if ForestLiana::UserSpace.const_defined?('DiscountController')
  ForestLiana::UserSpace::DiscountController.class_eval do
    include Utils::Forest::Commons

    NEED_SUPERADMIN = 'Para cambiar las condiciones de un descuento pactado, '\
                      'pregunte al administrador'.freeze

    def update
      set_discount
      PaperTrail.whodunnit = forest_email
      if action_needs_authorization
        render json: toast(NEED_SUPERADMIN), status: :bad_request
      else
        super
      end
    end

    private

    def set_discount
      @discount = Discount.find(params[:id])
    end

    def action_needs_authorization
      fixed_changed = params.fetch('data')['attributes'].keys.include? 'fixed'
      @discount.fixed && fixed_changed && !superadmin?
    end
  end
end
