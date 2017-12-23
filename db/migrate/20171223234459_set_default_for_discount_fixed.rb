class SetDefaultForDiscountFixed < ActiveRecord::Migration[5.0]
  def change
    change_column :discounts, :fixed, :boolean, default: true
  end
end
