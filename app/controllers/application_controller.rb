class ApplicationController < ActionController::API
  include Knock::Authenticable

  def authenticate_admin
    :FIXME
  end
end
