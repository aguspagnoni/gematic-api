class RemoveBillingInfo < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :billing_info_id

    remove_foreign_key :product_inputs, column: 'seller_company_id'
    remove_foreign_key :product_inputs, column: 'buyer_company_id'

    add_foreign_key :product_inputs, :companies, column: :seller_company_id, primary_key: :id
    add_foreign_key :product_inputs, :companies, column: :buyer_company_id, primary_key: :id
  end
end
