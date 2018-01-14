class AddSellerCompanyToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :seller_company_id, :integer
    add_foreign_key :orders, :companies, column: :seller_company_id, primary_key: :id
  end
end
