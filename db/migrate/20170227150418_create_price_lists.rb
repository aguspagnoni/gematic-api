class CreatePriceLists < ActiveRecord::Migration[5.0]
  def change
    create_table :price_lists do |t|
      t.string    :name
      t.date      :expires
      t.date      :valid_since
      t.references :client
      t.references :admin_user
      t.timestamps
    end
  end
end
