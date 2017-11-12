class Company < ApplicationRecord
  has_many :orders
  has_many :users
  has_many :branch_offices

  enum status: [:normal, :discontinued]
end
