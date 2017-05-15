class PriceList < ApplicationRecord
  has_many   :discounts
  has_many   :products, through: :discounts
  belongs_to :company
  belongs_to :next_price_list, class_name: 'PriceList',
                               foreign_key: 'next_price_list_id',
                               optional: true


  validates :name, :expires, :valid_since, presence: true
  validate  :non_recursive, on: :update
  validate  :expires_after_valid_date

  PERMITED_PARAMS = column_names - %w(id created_at updated_at next_price_list_id)

  before_update do
    if !@called_from_inside
      raise ActiveRecord::RecordNotSaved.new('Use business logic `update_new_copy` instead')
    end
  end

  def details
    discounts.map { |discount| [{ discount: discount, product: discount.product }] }
  end

  def update_new_copy(params)
    price_list_copy = self.dup
    params.each { |k, v| price_list_copy.send("#{k}=", v) }
    @called_from_inside = true
    price_list_copy.save
    update(next_price_list: price_list_copy)
    price_list_copy
  end

  private

  def non_recursive
    errors.add(:next_price_list_id, :price_list_recursion) if persisted? && id == next_price_list_id
  end

  def expires_after_valid_date
    errors.add(:expires, :expires_validation) if expires <= valid_since
  end
end
