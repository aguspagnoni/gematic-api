class PriceList < ApplicationRecord
  has_many   :discounts, dependent: :destroy
  has_many   :products, through: :discounts
  belongs_to :company
  belongs_to :admin_user
  belongs_to :authorizer, class_name: 'AdminUser', foreign_key: 'authorizer_id', optional: true

  validates_numericality_of :general_discount, greater_than_or_equal_to: 0.0, less_than: 100.0
  validates :name, :expires, :valid_since, presence: true
  validate :expires_after_valid_date

  scope :active, -> { where('valid_since <= :today AND expires >= :today', { today: Date.today }) }

  has_paper_trail

  PERMITED_PARAMS = column_names - %w(id created_at updated_at next_price_list_id)

  def self.for_company(company)
    active.where(company: company)
          .order('created_at desc')
          .limit(1)
          .first
  end

  def details
    discounts.map { |discount| [{ discount: discount, product: discount.product }] }
  end

  def authorized?
    !authorized_at.blank?
  end

  def authorize!(authorizer)
    @called_from_inside = true
    errors.add(:authorizer, :same_authorizer_validation) if admin_user == authorizer
    errors.add(:authorizer, :privilege_validation) if !authorizer.is_a?(AdminUser) || authorizer.back_office?
    raise ActiveRecord::RecordNotSaved if errors.present?
    update!(authorized_at: Time.zone.now, authorizer: authorizer)
  end

  def discount_multiplier
    1 - general_discount / 100.0
  end

  private

  def expires_after_valid_date
    errors.add(:expires, :expires_validation) if expires <= valid_since
  end
end
