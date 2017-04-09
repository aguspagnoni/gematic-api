class Discount < ApplicationRecord
  belongs_to :product
  belongs_to :price_list

  validate   :discount_smaller_than_gross_price

  def self.for_client_and_product(client, product)
    client_price_lists = PriceList.where(client: client)
    discount = where(product: product, price_list: client_price_lists)
               .order('updated_at desc')
               .limit(1)
    discount.empty? ? 0 : discount.first.cents
  end

  private

  def discount_smaller_than_gross_price
    errors.add(:cents, 'must be smaller than gross price') if cents > product.gross_price
  end
end
