class DropBillingInfoTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :billing_infos
  end
end
