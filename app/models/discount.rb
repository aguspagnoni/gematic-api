class Discount < ApplicationRecord
  belongs_to :product
  belongs_to :price_list
  delegate :company, to: :price_list
  validates :cents, numericality: true
  validate :human_error_over_product

  has_paper_trail

  def self.empty_discount
    OpenStruct.new(cents: 0)
  end

  def self.for_company_and_product(company, product)
    company_price_lists = PriceList.where(company: company)
    discount = where(product: product, price_list: company_price_lists)
               .order('updated_at desc')
               .limit(1)
    discount.empty? ? empty_discount : discount.first
  end

  # Note: It may happen that for some exception the discount is greater than the cost
  # => e.g. to loose on some product but overall still gain money.
  # => If this happens take into consideration adding a condition on WHO is creating this.
  # => only high rank admin companys should be able to create one exception to this rule.
  def human_error_over_product
    errors.add(:cents, :discount_cents_greater_product_cost) if cents > product.cost
  end
end
