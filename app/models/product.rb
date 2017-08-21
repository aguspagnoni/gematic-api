class Product < ApplicationRecord
  has_many :order_items
  has_many :orders, through: :order_items
  has_and_belongs_to_many :categories

  validates :name, :code, :gross_price, :cost, presence: true
  validates_numericality_of :gross_price, greater_than: 0
  validates_numericality_of :cost, greater_than_or_equal_to: 0, less_than: :gross_price

  enum status: [:normal, :discontinued]

  mount_uploader :image, PictureUploader

  has_paper_trail

  COST_MULTIPLIER = ENV.fetch('COST_MULTIPLIER', 1.5)

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
    standard_price * price_list.discount_multiplier
  end

  def standard_price
    cost * COST_MULTIPLIER
  end
end
