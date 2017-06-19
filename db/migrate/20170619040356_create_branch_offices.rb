class CreateBranchOffices < ActiveRecord::Migration[5.0]
  def change
    create_table :branch_offices do |t|
      t.references :company
      t.string :name
      t.string :address
      t.string :zipcode
      t.string :geolocation

      t.timestamps
    end

    remove_column :companies, :address
    remove_column :companies, :zip_code
  end
end
