class AddProductIdToProductPrices < ActiveRecord::Migration
  def change
    add_column :product_prices, :product_id, :integer
  end
end
