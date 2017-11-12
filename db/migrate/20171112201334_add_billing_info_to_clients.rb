class AddBillingInfoToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :address,      :string
    add_column :companies, :cuit,         :string
    add_column :companies, :condition,    :string
    add_column :companies, :razon_social, :string
    add_column :companies, :province,     :string
    add_column :companies, :localidad,    :string
    add_column :companies, :phone,        :string
    add_column :companies, :zipcode,      :string
    add_column :companies, :other_info,   :string
  end
end
