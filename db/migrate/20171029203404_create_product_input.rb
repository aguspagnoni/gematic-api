class CreateProductInput < ActiveRecord::Migration[5.0]
  def change
    create_table :product_inputs do |t|
      t.integer    :quantity, default: 0
      t.float      :unit_price
      t.string     :reference_number
      t.string     :image
      t.references :admin_user
      t.references :product
      t.references :seller_company
      t.references :buyer_company
      t.timestamps
    end
    add_foreign_key :product_inputs, :billing_infos, column: :seller_company_id, primary_key: :id
    add_foreign_key :product_inputs, :billing_infos, column: :buyer_company_id, primary_key: :id
  end
end
