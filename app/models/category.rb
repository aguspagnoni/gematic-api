class Category < ApplicationRecord
  has_one     :product
  belongs_to  :supercategory, class_name: 'Category',
                              foreign_key: 'category_id',
                              optional: true

  validate :non_recursive_categories, on: :update

  scope :root, -> { where(supercategory: nil) }

  RECURSIVE_MSG = 'must be different from parent Category'.freeze

  def subcategories
    @subcategories ||= Category.where(supercategory: self)
  end

  def self.tree
    root.each_with_object({}) do |root_category, tree_hash|
      tree_hash[root_category.name] = root_category.tree
      tree_hash
    end
  end

  def tree
    return nil if subcategories.empty?
    subcategories.each_with_object({}) do |subcategory, tree_hash|
      tree_hash[subcategory.name] = subcategory.tree
      tree_hash
    end
  end

  private

  def non_recursive_categories
    errors.add(:category_id, RECURSIVE_MSG) if persisted? && id == category_id
  end

  def root?
    supercategory.nil?
  end
end
