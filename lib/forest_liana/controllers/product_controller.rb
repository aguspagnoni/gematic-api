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
      user = AdminUser.find_by(email: whodunnit)
      user&.supervisor? || user&.superadmin?
    end
  end
end
