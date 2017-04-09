class AddImageToAdminUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :admin_users, :image, :string
  end
end
