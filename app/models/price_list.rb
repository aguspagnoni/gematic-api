class PriceList < ApplicationRecord
  has_many   :discounts
  has_many   :products, through: :discounts
  belongs_to :client

  before_update do
    raise ActiveRecord::RecordNotSaved.new('Use business logic `update_new_copy` instead')
  end

  def details
    discounts.map { |discount| [{ discount: discount, product: discount.product }] }
  end

  def update_new_copy(params)
    price_list_copy = self.dup
    params.each { |k, v| price_list_copy.send("#{k}=", v) }
    price_list_copy.save!
  end
end
