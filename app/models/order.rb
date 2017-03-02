class Order < ApplicationRecord
  has_and_belongs_to_many :products
  enum status: [:no_state, :not_confirmed, :confirmed, :with_invoice]
end
