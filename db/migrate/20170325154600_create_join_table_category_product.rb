class CreateJoinTableCategoryProduct < ActiveRecord::Migration[5.0]
  def change
    create_join_table :products, :categories do |t|
      t.index [:category_id, :product_id]
    end
  end
end
