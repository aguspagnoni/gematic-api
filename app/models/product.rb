class Product < ApplicationRecord
  has_many :order_items
  has_many :orders, through: :order_items
  has_and_belongs_to_many :category
end
