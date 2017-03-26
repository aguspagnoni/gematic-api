class Discount < ApplicationRecord
  belongs_to :product
  belongs_to :price_list

  validate   :discount_smaller_than_gross_price

  private

  def discount_smaller_than_gross_price
    errors.add(:cents, 'must be smaller than gross price') if cents > product.gross_price
  end
end
