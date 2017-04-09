class Order < ApplicationRecord
  has_many    :order_items
  has_many    :products, through: :order_items
  belongs_to  :client
  STATUSES = [:not_confirmed, :confirmed, :with_invoice].freeze # defaults to 0 -> :not_confirmed
  enum status: STATUSES

  scope :due_today, -> { where(delivery_date: Time.zone.today) }

  def gross_total
    order_items.map do |item|
      item.quantity * (item.product.gross_price - Discount.for_client_and_product(client, item.product))
    end.sum
  end
end
