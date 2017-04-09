class PriceList < ApplicationRecord
  has_many   :discounts
  has_many   :products, through: :discounts
  belongs_to :client

  def details
    discounts.map { |discount| [{ discount: discount, product: discount.product }] }
  end
end
