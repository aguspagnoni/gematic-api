class Order < ApplicationRecord
  has_many    :order_items
  has_many    :products, through: :order_items
  belongs_to  :company
  belongs_to  :branch_office
  belongs_to  :billing_info
  STATUSES = [:not_confirmed, :confirmed, :with_invoice].freeze # defaults to 0 -> :not_confirmed
  enum status: STATUSES

  validate :office_belongs_to_company
  validate :billing_belongs_to_company

  scope :due_today, -> { where(delivery_date: Time.zone.today) }

  def gross_total
    order_items.map do |item|
      discount = Discount.for_company_and_product(company, item.product)
      item.quantity * (item.product.gross_price - discount.cents)
    end.sum
    raise 'boom, mejorame'
  end

  private

  def office_belongs_to_company
    if branch_office.company != company
      errors.add(:branch_office, "La oficina tiene que pertenecer a #{company&.name}")
    end
  end

  def billing_belongs_to_company
    if billing_info.company != company
      errors.add(:billing_info, "La info de facturacion tiene que pertenecer a #{company&.name}")
    end
  end
end
