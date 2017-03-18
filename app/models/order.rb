class Order < ApplicationRecord
  has_and_belongs_to_many :products
  STATUSES = [:no_state, :not_confirmed, :confirmed, :with_invoice] # defaults to 0 -> :no_state
  enum status: STATUSES

  scope :due_today, -> { where(delivery_date: Time.zone.today) }
end
