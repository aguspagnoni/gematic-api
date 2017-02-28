class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :address
      t.string :email
      t.string :family_name
      t.string :name
      t.string :phone_number
      t.string :cellphone
      t.string :job_position
      t.timestamps
    end
  end
end
