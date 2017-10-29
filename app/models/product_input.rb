class ProductInput < ApplicationRecord
  belongs_to :seller_company, :class_name => 'BillingInfo'
  belongs_to :buyer_company, :class_name => 'BillingInfo'
  belongs_to :admin_user
  belongs_to :product

  mount_uploader :image, PictureUploader

  validates_presence_of :product, :admin_user, :buyer_company, :seller_company,
                        :reference_number, :unit_price, :quantity
  validates_numericality_of :unit_price, :quantity, greater_than: 0
  validate :validate_companies, :validate_input_already_registered

  before_save :update_product_stock

  private

  def validate_companies
    errors.add(:seller_company, :product_input_same_company) if buyer_company == seller_company
  end

  def validate_input_already_registered
    errors.add(:seller_company, :product_input_already_registered) if already_exists?
  end

  def already_exists?
    ProductInput.exists?(seller_company: seller_company, reference_number: reference_number)
  end

  def update_product_stock
    product.update!(stock: product.stock + quantity)
  end
end
