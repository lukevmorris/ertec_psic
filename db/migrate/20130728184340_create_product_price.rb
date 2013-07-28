class CreateProductPrice < ActiveRecord::Migration
  def change
    create_table :product_prices do |t|
      t.timestamps
      t.integer :stocking_distributor
      t.integer :non_stocking_distributor
      t.integer :managed_service_provider
      t.integer :installer_partner
      t.integer :list
    end
  end
end
