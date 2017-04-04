class PriceList < ApplicationRecord
  has_many :discounts
  has_many :products, through: :discounts

  def details
    discounts.map { |discount| [{ discount: discount, product: discount.product }] }
  end
end
