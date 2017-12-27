if ForestLiana::UserSpace.const_defined?('ProductInputController')
  ForestLiana::UserSpace::ProductInputController.class_eval do
    include Utils::Forest::ControllerCommons

    def create
      set_admin_user
      super
    end

    def set_admin_user
      admin_params = { id: admin_user.id }
      params['data']['relationships']['admin_user']['data'] = admin_params
    end
  end
end
