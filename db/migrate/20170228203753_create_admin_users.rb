class CreateAdminUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_users do |t|
      t.integer :privilege
      t.string :name
      t.string :email
      t.string :family_name

      t.timestamps
    end
  end
end
