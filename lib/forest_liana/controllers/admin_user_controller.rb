if ForestLiana::UserSpace.const_defined?('AdminUserController')
  ForestLiana::UserSpace::AdminUserController.class_eval do
    def index
      whodunnit = forest_user["data"]["data"]["email"]
      if !admin?(whodunnit)
        Rollbar.silenced {
          raise 'Solo para administradores'
        }
      else
        super
      end
    end

    private

    def admin?(whodunnit)
      AdminUser.find_by(email: whodunnit)&.superadmin?
    end
  end
end
