class AddIndexToProductOnName < ActiveRecord::Migration[5.0]
  def change
    add_index :products, :name, using: :btree
    execute "CREATE INDEX product_name_like_index ON products USING gin (name gin_trgm_ops);"
  end
end
