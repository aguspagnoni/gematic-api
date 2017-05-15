class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :family_name
      t.string :name
      t.string :phone_number
      t.string :cellphone
      t.string :job_position
      t.references :company
      t.timestamps
    end
  end
end
