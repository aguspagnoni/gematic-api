class Category < ApplicationRecord
  has_and_belongs_to_many :products
  has_one                 :subcategory, class_name: 'Category', foreign_key: 'category_id'

  validate                :non_recursive_subcategory, on: :update

  private

  def non_recursive_subcategory
    errors.add(:category_id, 'must be different from Subcategory') if persisted? && id == category_id
  end
end
