class OrderItem < ApplicationRecord
  self.table_name = 'orders_products'
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
end
