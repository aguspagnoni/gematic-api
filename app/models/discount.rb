class Discount < ApplicationRecord
  belongs_to :product
  belongs_to :price_list
  delegate :client, to: :price_list
  validates_numericality_of :cents

  def self.empty_discount
    OpenStruct.new(cents: 0)
  end

  def self.for_client_and_product(client, product)
    client_price_lists = PriceList.where(client: client)
    discount = where(product: product, price_list: client_price_lists)
               .order('updated_at desc')
               .limit(1)
    discount.empty? ? empty_discount : discount.first
  end
end
