class CreateBillingInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :billing_infos do |t|
      t.string     :address
      t.string     :cuit
      t.string     :condition
      t.string     :razon_social
      t.references :company
      t.timestamps
    end
  end
end
