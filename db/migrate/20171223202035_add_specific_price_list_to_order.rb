class AddSpecificPriceListToOrder < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :custom_price_list
    add_foreign_key :orders, :price_lists, column: :custom_price_list_id, primary_key: :id
  end
end
