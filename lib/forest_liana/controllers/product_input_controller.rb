if ForestLiana::UserSpace.const_defined?('ProductInputController')
  ForestLiana::UserSpace::ProductInputController.class_eval do
    def create
      set_admin_user
      super
    end

    def set_admin_user
      admin_user = AdminUser.find_by(email: whodunnit)
      admin_params = { id: admin_user.id }
      params['data']['relationships']['admin_user']['data'] = admin_params
    end

    def whodunnit
      forest_user['data']['data']['email']
    end
  end
end
