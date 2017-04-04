class Client < ApplicationRecord
  has_many :billing_info
  has_many :orders
end
