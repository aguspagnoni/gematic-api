class Company < ApplicationRecord
  has_many :orders
  has_many :users
  has_many :branch_offices

  enum status: [:normal, :discontinued]

  validates :cuit, :razon_social, :name, presence: true, uniqueness: true

  normalize :cuit, :name, with: [:downcase, :strip, :without_strange_chars]
end
