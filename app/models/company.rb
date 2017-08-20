class Company < ApplicationRecord
  has_many :billing_info
  has_many :orders
  has_many :users
  has_many :branch_offices

  enum status: [:normal, :discontinued]
end
