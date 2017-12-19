# ForestLiana::ApplicationController takes care of the authentication for you.
class Forest::PriceListsController < ForestLiana::ApplicationController

  def download_txt
    ReportMailer.pricelist_summary(price_lists.first, user).deliver_now
    toast_response('Revise su correo electronico', :ok)
  rescue => e
    Rails.logger.debug("Error al armar ReportsMailer: #{e}")
    toast_response('No pudimos armar el reporte, contacte al Administrador del sitio', :bad_request)
  end

  def authorize_list
    if user.present? && able_to_authorize_list?(user)
      msg    = 'Lista/s autorizadas correctamente'
      status = :ok
      save_authorization_details
    else
      msg    = 'Pregunte a un superivor para que autorize esta lista'
      status = :bad_request
    end
    toast_response(msg, status)
  end

  private

  def user
    @admin_user ||= AdminUser.find_by(email: forest_user["data"]["data"]["email"])
  end

  def able_to_authorize_list?(user)
    user&.supervisor? || user&.superadmin?
  end

  def save_authorization_details
    price_lists.each do |price_list|
      next if price_list.authorizer.present?
      price_list.update(authorizer: user, authorized_at: Time.now)
    end
  end

  def price_lists
    PriceList.where(id: params[:data][:attributes][:ids])
  end

  def toast_response(msg, status)
    key = status == :ok ? 'success' : 'error'
    render json: { key => msg }, status: status
  end
end
