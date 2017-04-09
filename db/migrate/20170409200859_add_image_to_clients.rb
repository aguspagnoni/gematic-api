class AddImageToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :image, :string
  end
end
