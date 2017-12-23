class ReportMailer < ApplicationMailer

  def pricelist_summary(pricelist, recipient)
    @pricelist = pricelist
    @recipient = recipient
    @header_data = pricelist_header_data_hash
    attachment_name = "lista_precio_#{pricelist.name.split(' ').join('_')}.html"
    attachments[attachment_name] = render :pricelist_summary
    mail(to: recipient.email, subject: I18n.t('mailers.pricelist_summary.subject'))
  end

  def order_summary(order, recipient)
    @order          = order
    @pricelist      = order.price_list
    @recipient      = recipient
    @header_data    = order_header_data_hash
    @savings_percentage = 100 * (1 - order.gross_total / order.gross_without_discount)
    @total_savings  = order.gross_without_discount - order.gross_total
    attachment_name = "resumen_de_pedido_#{order.id}.html"
    attachments[attachment_name] = render :order_summary
    byebug
    mail(to: recipient.email, subject: I18n.t('mailers.order_summary.subject'))
  end

  private

  def pricelist_header_data_hash
    [
      { label: 'Empresa',              text: @pricelist.company.name },
      { label: 'Valido desde (d/m/a)', text: @pricelist.valid_since.strftime("%d/%m/%Y") },
      { label: 'Valido hasta (d/m/a)', text: @pricelist.expires.strftime("%d/%m/%Y") },
      { label: 'Descuento General',    text: @pricelist.general_discount },
      { label: 'Agente responsable',   text: "#{@recipient.name} (#{@recipient.email})" }
    ]
  end

  def order_header_data_hash
    [
      { label: 'Empresa',                   text: @order.company.name },
      { label: 'Fecha de entrega (d/m/a)',  text: @order.delivery_date.strftime("%d/%m/%Y") },
      { label: 'Oficina > Site',            text: @order.branch_office.name },
      { label: 'Oficina > Codigo Postal',   text: @order.branch_office.zipcode },
      { label: 'Oficina > Telefono',        text: @order.branch_office.phone },
      { label: 'Agente responsable',        text: "#{@recipient.name} (#{@recipient.email})" }
    ]
  end
end
