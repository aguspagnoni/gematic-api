if ForestLiana::UserSpace.const_defined?('AdminUserController')
  ForestLiana::UserSpace::AdminUserController.class_eval do
    include Utils::Forest::Commons

    def index
      if admin_tab? && !superadmin?
        Rollbar.silenced {
          raise 'Solo para administradores'
        }
      else
        super
      end
    end

    private

    def admin_tab?
      !input_field_search? && (params['collection'] == 'admin_users' || params['collection'] == 'AdminUser')
    end

    def input_field_search?
      !params['search'].nil?
    end
  end
end
