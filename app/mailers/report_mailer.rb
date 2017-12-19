class ReportMailer < ApplicationMailer

  def pricelist_summary(pricelist, recipient)
    @pricelist = pricelist
    @recipient = recipient
    @header_data = header_data_hash
    attachment_name = "lista_precio_#{pricelist.name.split(' ').join('_')}"
    attachments[attachment_name] = render :pricelist_summary
    mail(to: recipient.email, subject: I18n.t('mailers.pricelist_summary.subject'))
  end

  private

  def header_data_hash
    [
      { label: 'Empresa',                    text: @pricelist.company.name },
      { label: 'Valido desde (dia/mes/año)', text: @pricelist.valid_since.strftime("%d/%m/%Y") },
      { label: 'Valido hasta (dia/mes/año)', text: @pricelist.expires.strftime("%d/%m/%Y") },
      { label: 'Descuento General',          text: @pricelist.general_discount },
      { label: 'Agente responsable',         text: "#{@recipient.name} (#{@recipient.email})" }
    ]
  end
end
