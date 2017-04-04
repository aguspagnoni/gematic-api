class Order < ApplicationRecord
  has_and_belongs_to_many :products
  belongs_to              :client
  STATUSES = [:not_confirmed, :confirmed, :with_invoice].freeze # defaults to 0 -> :not_confirmed
  enum status: STATUSES

  scope :due_today, -> { where(delivery_date: Time.zone.today) }

  def gross_total
    products.sum(:gross_price)
  end
end
