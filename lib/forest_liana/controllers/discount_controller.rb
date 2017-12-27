if ForestLiana::UserSpace.const_defined?('DiscountController')
  ForestLiana::UserSpace::DiscountController.class_eval do
    include Utils::Forest::ControllerCommons

    NEED_SUPERADMIN ||= 'Para cambiar las condiciones de un descuento pactado, '\
                      'pregunte al administrador'.freeze

    before_action :handle_discount_cents, only: [:create, :update]

    def update
      PaperTrail.whodunnit = forest_email
      if action_needs_authorization
        render json: toast(NEED_SUPERADMIN), status: :bad_request
      else
        super
      end
    end

    private

    def handle_discount_cents
      return unless desired_price.present? && desired_price.positive?
      calculated_cents = Discount.cents_for_desired_price(desired_price, price_list, product)
      set_param_cents(calculated_cents)
    end

    def discount
      @discount ||= Discount.find(params[:id])
    end

    def price_list
      price_list_id = params['data']['relationships']['price_list']['data']['id']
      @price_list ||= PriceList.find(price_list_id)
    end

    def product
      product_id = params['data']['relationships']['product']['data']['id']
      @product ||= Product.find(product_id)
    end

    def desired_price
      params['data']['attributes']['final_price']
    end

    def set_param_cents(cents)
      params['data']['attributes']['cents'] = cents
    end

    def action_needs_authorization
      fixed_changed = params.fetch('data')['attributes'].keys.include? 'fixed'
      discount.fixed && fixed_changed && !superadmin?
    end
  end
end
