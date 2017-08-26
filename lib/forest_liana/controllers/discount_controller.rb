if ForestLiana::UserSpace.const_defined?('DiscountController')
  ForestLiana::UserSpace::DiscountController.class_eval do

    def update
      pesos_to_cents
      super
    end

    def create
      pesos_to_cents
      super
    end

    private

    def pesos_to_cents
      raise 'boom, poneme en pesos'
      str      = params["data"]["attributes"]["cents"].to_f.to_s
      splitted = str.split('.')
      cents    = splitted.last.ljust(2, '0')
      units    = splitted.first
      params["data"]["attributes"]["cents"] = "#{units}#{cents}".to_i
    end
  end
end
