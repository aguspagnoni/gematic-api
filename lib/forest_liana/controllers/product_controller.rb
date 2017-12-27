if ForestLiana::UserSpace.const_defined?('ProductController')
  ForestLiana::UserSpace::ProductController.class_eval do
    include Utils::Forest::ControllerCommons

    def update
      PaperTrail.whodunnit = forest_email
      if cost_changed? && !at_least_supervisor?
        msg = 'Consulte a un supervisor como cambiar el costo'
        render json: toast(msg), status: :unprocessable_entity
      else
        super
      end
    end

    private

    def cost_changed?
      params.fetch('data')["attributes"]["cost"].present?
    end
  end
end
