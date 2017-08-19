class Product < ApplicationRecord
  has_many :order_items
  has_many :orders, through: :order_items
  has_and_belongs_to_many :categories

  validates :name, :code, :gross_price, :cost, presence: true
  validates_numericality_of :gross_price, greater_than: 0
  validates_numericality_of :cost, greater_or_equal_than: 0, less_than: :gross_price

  mount_uploader :image, PictureUploader

  has_paper_trail
end
