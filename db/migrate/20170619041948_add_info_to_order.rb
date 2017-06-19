class AddInfoToOrder < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :billing_info, index: true
    add_reference :orders, :branch_office, index: true
  end
end
