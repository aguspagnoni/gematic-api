class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :image
      t.string  :code
      t.integer :gross_price
      t.integer :cost
      t.text    :description
      t.timestamps
    end
    add_index :products, :code, unique: true
  end
end
