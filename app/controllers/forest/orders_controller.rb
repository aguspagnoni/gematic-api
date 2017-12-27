# ForestLiana::ApplicationController takes care of the authentication for you.
class Forest::OrdersController < Forest::GematicBaseController

  def send_summary
    ReportMailer.order_summary(orders.first, admin_user).deliver_now
    toast_response('Revise su correo electronico', :ok)
  rescue => e
    Rails.logger.debug("Error al armar ReportsMailer: #{e}")
    Rails.logger.debug("#{e.backtrace.first(5)}")
    toast_response('No pudimos armar el reporte, contacte al Administrador del sitio', :bad_request)
  end

  def duplicate
    Gematic::Functions.duplicate_order(orders.first)
  end

  def from_price_list
    Gematic::Functions.populate_order_with_price_list(orders.first)
  end

  private

  def orders
    Order.where(id: params[:data][:attributes][:ids])
  end
end
