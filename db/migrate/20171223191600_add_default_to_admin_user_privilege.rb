class AddDefaultToAdminUserPrivilege < ActiveRecord::Migration[5.0]
  def change
    change_column :admin_users, :privilege, :integer, default: 0
  end
end
