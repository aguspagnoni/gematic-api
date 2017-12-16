class AddExtraColumnToProduct < ActiveRecord::Migration[5.0]
  def up
    rename_column :products, :code, :old_code
    add_column    :products, :code, :string
  end

  def down
    rename_column :products, :old_code, :code
  end
end
