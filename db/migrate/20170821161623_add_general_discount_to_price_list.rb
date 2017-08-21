class AddGeneralDiscountToPriceList < ActiveRecord::Migration[5.0]
  def change
    add_column :price_lists, :general_discount, :float, default: 0.0
  end
end
