class AddFieldsToBillingInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :billing_infos, :province, :string
    add_column :billing_infos, :localidad, :string
    add_column :billing_infos, :phone, :string
    add_column :billing_infos, :zipcode, :string
    add_column :billing_infos, :other_info, :string

    add_column :branch_offices, :phone, :string
  end
end
