class ChangeDiscountCentsToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :discounts, :cents, :float, default: 0.0
  end
end
