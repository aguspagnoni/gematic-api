class CreateDiscounts < ActiveRecord::Migration[5.0]
  def change
    create_table :discounts do |t|
      t.integer    :cents
      t.references :product
      t.references :price_list
      t.timestamps
    end
    add_index :discounts, [:product_id, :price_list_id]
  end
end
