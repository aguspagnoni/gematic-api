class RemovePriceListColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :price_lists, :active
    remove_column :price_lists, :next_price_list_id
  end
end
