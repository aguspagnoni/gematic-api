class AddIndexToProductCode < ActiveRecord::Migration[5.0]
  def change
    add_index :products, :code, unique: true
  end
end
