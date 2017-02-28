class CreateJoinTableOrderProduct < ActiveRecord::Migration[5.0]
  def change
    create_join_table :products, :orders do |t|
      t.index [:product_id, :order_id]
    end
  end
end
