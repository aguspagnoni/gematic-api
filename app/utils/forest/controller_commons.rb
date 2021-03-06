module Utils
  module Forest
    module ControllerCommons
      def toast(msg = '', failed = true)
        { "errors" => [ { "detail" => msg } ] }
      end

      def forest_email
        forest_user["data"]["data"]["email"]
      end

      def forest_name
        forest_user["data"]["data"]["first_name"]
      end

      def forest_family_name
        forest_user["data"]["data"]["last_name"]
      end

      def superadmin?
        admin_user.superadmin?
      end

      def at_least_supervisor?
        admin_user.supervisor? || admin_user.superadmin?
      end

      def admin_user
        user = AdminUser.find_by(email: forest_email)
        if user.nil?
          Rails.logger.info("Intentando crear usuario: #{forest_email}")
          user = AdminUser.create!(email: forest_email,
                                   name: forest_name,
                                   family_name: forest_family_name,
                                   password: 'notused',
                                   password_confirmation: 'notused')
        end
        user
      end
    end
  end
end
