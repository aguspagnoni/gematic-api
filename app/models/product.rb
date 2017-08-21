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

  def standard_price
    cost * 1.5 # TODO: this should be able to be modified by config
  end

  def price_within(price_list)
    after_general_discount = standard_price * price_list.discount_multiplier
    discount = price_list.discounts.find { |discount| discount.product == self }
    discount.present? ?
      after_general_discount - discount.cents :
      after_general_discount
  end
end
