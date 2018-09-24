class Order < ApplicationRecord
  has_many    :order_items, dependent: :destroy
  has_many    :products, through: :order_items
  belongs_to  :custom_price_list, class_name: 'PriceList',
                                  foreign_key: 'custom_price_list_id',
                                  optional: true
  belongs_to  :company
  belongs_to  :seller_company, class_name: 'Company'
  belongs_to  :branch_office

  VALID_SELLER_CUITS = ['30691235021', '30711805393', '30711006997']
  STATUSES = [:presupuesto, :confirmado, :con_factura, :anulado].freeze # defaults to 0 -> :presupuesto
  enum status: STATUSES

  after_save  :change_stock

  validate :validate_correct_status_transitions
  validate :office_belongs_to_company
  validate :who_can_buy_products

  scope :due_today, -> { where(delivery_date: Time.zone.today) }

  has_paper_trail

  def gross_total
    @gross_total ||= sum_on_items { |item| item.quantity * item.product.price(price_list) }
  end

  def gross_without_discount
    @gross_without_discount ||= sum_on_items { |item| item.quantity * item.product.standard_price }
  end

  def price_list
    @price_list ||= custom_price_list || PriceList.for_company(company)
  end

  private

  def sum_on_items(&block)
    order_items.map do |item|
      block.call(item)
    end.sum.round(2)
  end

  def office_belongs_to_company
    if branch_office.nil?
      errors.add(:branch_office, 'Debe eligir la oficina de la empresa')
    elsif branch_office.company != company
      errors.add(:branch_office, "La oficina tiene que pertenecer a #{company&.name}")
    end
  end

  def who_can_buy_products
    seller_cuit = seller_company&.cuit&.tr('-', '')
    valid_company = VALID_SELLER_CUITS.include?(seller_cuit)
    errors.add(:seller_company_id, :incorrect_seller_company) unless valid_company
  end

  def validate_correct_status_transitions
    correct_transitions = [
      ['presupuesto', 'confirmado'],
      ['presupuesto', 'anulado'],
      ['confirmado',  'con_factura'],
      ['confirmado',  'anulado'],
      ['con_factura', 'anulado'],
      ['anulado',     'presupuesto']
    ]
    if changes['status'] && !correct_transitions.include?(changes['status'])
      errors.add(:status, :order_invalid_status_change)
    end
  end

  def change_stock
    case changes['status']
    when ['presupuesto', 'confirmado']
      order_items.each do |item|
        item.product.reduce_stock(item.quantity)
      end
    when ['confirmado',  'anulado'], ['con_factura', 'anulado']
      order_items.each do |item|
        item.product.reduce_stock(-item.quantity)
      end
    end
  end
end
