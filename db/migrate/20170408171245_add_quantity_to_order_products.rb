class AddQuantityToOrderProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :orders_products, :quantity, :integer, null: false
  end
end
