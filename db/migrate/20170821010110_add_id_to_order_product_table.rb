class AddIdToOrderProductTable < ActiveRecord::Migration[5.0]
  def change
    add_column :orders_products, :id, :primary_key
  end
end
