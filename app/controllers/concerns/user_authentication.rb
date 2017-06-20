module UserAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenicate_user
  end
end
