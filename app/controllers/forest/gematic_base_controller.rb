class Forest::GematicBaseController < ForestLiana::ApplicationController
  def admin_user
    @admin_user ||= AdminUser.find_by(email: forest_user["data"]["data"]["email"])
  end

  def toast_response(msg, status)
    key = status == :ok ? 'success' : 'error'
    render json: { key => msg }, status: status
  end
end
