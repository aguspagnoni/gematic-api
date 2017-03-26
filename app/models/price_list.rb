class PriceList < ApplicationRecord
  has_many :discounts
  has_many :products, through: :discounts

  def gross_total
    products.sum(:gross_price) - discounts.sum(:cents)
  end

  def details
    discounts.map { |discount| [{discount: discount, product: discount.product}] }
  end
end
