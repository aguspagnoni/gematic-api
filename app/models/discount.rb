class Discount < ApplicationRecord
  belongs_to :product
  belongs_to :price_list
  delegate :company, to: :price_list
  validates :cents, numericality: true
  validate :human_error_over_product

  has_paper_trail

  before_save   :set_final_price, if: -> { fixed && final_price.blank? }
  before_update do
    errors.add(:cents, :fixed_discount_change_cents) if fixed && cents_changed?
  end

  def apply
    fixed ? final_price : calculate_price_now
  end

  def self.empty_discount
    OpenStruct.new(cents: 0)
  end

  def self.for_company_and_product(company, product)
    company_price_lists = PriceList.active.where(company: company)
    discount = where(product: product, price_list: company_price_lists)
               .order('created_at desc')
               .limit(1)
    discount.empty? ? empty_discount : discount.first
  end

  private

  def set_final_price
    self.final_price = calculate_price_now
  end

  def calculate_price_now
    product.price_within(price_list) - cents
  end

  # Note: It may happen that for some exception the discount is greater than the cost
  # => e.g. to loose on some product but overall still gain money.
  # => If this happens take into consideration adding a condition on WHO is creating this.
  # => only high rank admin companys should be able to create one exception to this rule.
  def human_error_over_product
    errors.add(:cents, :discount_cents_greater_product_cost) if cents > product.cost
  end
end
