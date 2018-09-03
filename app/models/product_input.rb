class ProductInput < ApplicationRecord
  belongs_to :seller_company, :class_name => 'Company'
  belongs_to :buyer_company, :class_name => 'Company'
  belongs_to :admin_user
  belongs_to :product

  mount_uploader :image, PictureUploader

  validates_presence_of :product, :admin_user, :buyer_company, :seller_company,
                        :reference_number, :unit_price, :quantity
  validates_numericality_of :unit_price, :quantity, greater_than: 0
  validate :different_companies, :who_can_buy_products

  before_save :product_input_already_registered
  after_save  :update_product_stock

  VALID_BUYERS = ["ilit facility services s.a.", "famtech sa", "gematic srl"]

  private

  def different_companies
    errors.add(:seller_company, :product_input_same_company) if buyer_company == seller_company
  end

  def product_input_already_registered
    if product_input_repeated?
      errors.add(:seller_company, :product_input_already_registered)
      throw(:abort)
    end
  end

  def who_can_buy_products
    valid_company = VALID_BUYERS.include?(buyer_company&.razon_social&.downcase)
    errors.add(:buyer_company, :incorrect_buyer_company) unless valid_company
  end

  def product_input_repeated?
    ProductInput.exists?(seller_company: seller_company, reference_number: reference_number)
  end

  def update_product_stock
    product.update!(stock: product.stock + quantity)
  end
end
