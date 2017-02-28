class CreateCatgories < ActiveRecord::Migration[5.0]
  def change
    create_table :catgories do |t|
      t.string :name
      t.references :category
      t.timestamps
    end
  end
end
