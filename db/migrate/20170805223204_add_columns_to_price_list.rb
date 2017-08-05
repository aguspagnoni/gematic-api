class AddColumnsToPriceList < ActiveRecord::Migration[5.0]
  def change
    add_column :price_lists, :active, :boolean, default: true
    add_column :price_lists, :authorized_at, :datetime
    add_reference :price_lists, :authorizer, references: :admin_users, index: true
    add_foreign_key :price_lists, :admin_users, column: :authorizer_id
  end
end
