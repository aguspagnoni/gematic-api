class Order < ApplicationRecord
  has_many    :order_items
  has_many    :products, through: :order_items
  belongs_to  :company
  belongs_to  :branch_office
  STATUSES = [:not_confirmed, :confirmed, :with_invoice].freeze # defaults to 0 -> :not_confirmed
  enum status: STATUSES

  after_save  :reduce_products_stock

  validate :office_belongs_to_company

  scope :due_today, -> { where(delivery_date: Time.zone.today) }

  def gross_total
    @gross_total ||= sum_on_items { |item| item.quantity * item.product.price(price_list) }
  end

  def gross_without_discount
    @gross_without_discount ||= sum_on_items { |item| item.quantity * item.product.standard_price }
  end

  def price_list
    @price_list ||= PriceList.for_company(company)
  end

  private

  def sum_on_items(&block)
    order_items.map do |item|
      block.call(item)
    end.sum.round(2)
  end

  def office_belongs_to_company
    if branch_office.company != company
      errors.add(:branch_office, "La oficina tiene que pertenecer a #{company&.name}")
    end
  end

  def reduce_products_stock
    if changes['status'] == ['not_confirmed', 'confirmed']
      order_items.each do |item|
        item.product.reduce_stock(item.quantity)
      end
    end
  end
end
