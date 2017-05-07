class AddNextCopyToPriceLists < ActiveRecord::Migration[5.0]
  def change
    add_reference :price_lists, :next_price_list, references: :price_lists, index: true
    add_foreign_key :price_lists, :price_lists, column: :next_price_list_id
  end
end
