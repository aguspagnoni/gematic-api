class AddAttributesToDiscount < ActiveRecord::Migration[5.0]
  def change
    add_column :discounts, :fixed, :boolean, default: false
    add_column :discounts, :final_price, :float
  end
end
