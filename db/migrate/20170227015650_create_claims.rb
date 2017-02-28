class CreateClaims < ActiveRecord::Migration[5.0]
  def change
    create_table :claims do |t|
      t.text      :description
      t.references :order
      t.references :client
      t.references :admin_user
      t.timestamps
    end
  end
end
