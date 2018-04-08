# ForestLiana::ApplicationController takes care of the authentication for you.
class Forest::OrdersController < Forest::GematicBaseController
  def send_summary
    if order.not_confirmed?
      toast_response('Necesita ser autorizado', :bad_request)
    else
      ReportMailer.order_summary(order, admin_user).deliver_now
      toast_response('Revise su correo electronico', :ok)
    end
  rescue StandardError => e
    Rails.logger.debug("Error al armar ReportsMailer: #{e}")
    Rails.logger.debug(e.backtrace.first(5).to_s)
    toast_response('No pudimos armar el reporte, contacte al Administrador del sitio', :bad_request)
  end

  def authorize
    order.confirmed!
    toast_response('Autorizado ok!', :ok)
  rescue ActiveRecord::RecordInvalid => error
    toast_response('No se pudo autorizar, el equipo tecnico ha sido notificado', :bad_request)
    Rollbar.error(order, error)
  end

  def duplicate
    Gematic::Functions.duplicate_order(order)
  end

  def from_price_list
    price_list = order.custom_price_list || PriceList.for_company(order.company)
    if price_list.nil?
      toast_response('No hay lista de precio de donde basarse', :bad_request)
    else
      Gematic::Functions.populate_order_with_price_list(order, price_list)
    end
  end

  private

  def order
    Order.where(id: params[:data][:attributes][:ids]).first
  end
end
