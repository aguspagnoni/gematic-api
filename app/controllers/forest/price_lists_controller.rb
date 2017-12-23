# ForestLiana::ApplicationController takes care of the authentication for you.
class Forest::PriceListsController < ForestLiana::ApplicationController

  def send_summary
    ReportMailer.pricelist_summary(price_lists.first, admin_user).deliver_now
    toast_response('Revise su correo electronico', :ok)
  rescue => e
    Rails.logger.debug("Error al armar ReportsMailer: #{e}")
    Rails.logger.debug("#{e.backtrace.first(5)}")
    toast_response('No pudimos armar el reporte, contacte al Administrador del sitio', :bad_request)
  end

  def authorize_list
    if admin_user.present? && able_to_authorize_list?(admin_user)
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

  def able_to_authorize_list?
    admin_user&.supervisor? || admin_user&.superadmin?
  end

  def save_authorization_details
    price_lists.each do |price_list|
      next if price_list.authorizer.present?
      price_list.update(authorizer: admin_user, authorized_at: Time.now)
    end
  end

  def price_lists
    PriceList.where(id: params[:data][:attributes][:ids])
  end
end
