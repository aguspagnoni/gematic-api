class Discount < ApplicationRecord
  belongs_to :product
  belongs_to :price_list
  validates_numericality_of :cents

  def self.for_client_and_product(client, product)
    client_price_lists = PriceList.where(client: client)
    discount = where(product: product, price_list: client_price_lists)
               .order('updated_at desc')
               .limit(1)
    discount.empty? ? 0 : discount.first.cents
  end
end
