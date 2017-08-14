class ChangeCentsToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :gross_price, :float
    change_column :products, :cost, :float
  end
end
