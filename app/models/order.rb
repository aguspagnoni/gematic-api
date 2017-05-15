class Order < ApplicationRecord
  has_many    :order_items
  has_many    :products, through: :order_items
  belongs_to  :company
  STATUSES = [:not_confirmed, :confirmed, :with_invoice].freeze # defaults to 0 -> :not_confirmed
  enum status: STATUSES

  scope :due_today, -> { where(delivery_date: Time.zone.today) }

  def gross_total
    order_items.map do |item|
      discount = Discount.for_company_and_product(company, item.product)
      item.quantity * (item.product.gross_price - discount.cents)
    end.sum
  end
end
