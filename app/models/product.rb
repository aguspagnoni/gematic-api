class Product < ApplicationRecord
  has_many   :order_items
  has_many   :orders, through: :order_items
  belongs_to :category

  validates :name, :code, :gross_price, :cost, presence: true
  validates_numericality_of :gross_price, greater_than: 0
  validates_numericality_of :cost, greater_than_or_equal_to: 0, less_than: :gross_price

  enum status: [:normal, :discontinued]

  mount_uploader :image, PictureUploader

  has_paper_trail

  COST_MULTIPLIER      = ENV.fetch('COST_MULTIPLIER', 1.5).to_f
  GEMATIC_BARCODE_BASE = '7462842' # 7-GMATIC in numbers ;)

  def price(price_list = nil)
    if price_list.blank?
      standard_price
    else
      discount = price_list.discounts.find { |discount| discount.product == self }
      discount.present? ?
        discount.apply :
        price_within(price_list)
    end
  end

  def price_within(price_list)
    return standard_price if price_list.nil?
    standard_price * price_list.discount_multiplier
  end

  def standard_price
    cost * COST_MULTIPLIER
  end

  def reduce_stock(amount)
    self.stock -= amount
    save!
  end
end
