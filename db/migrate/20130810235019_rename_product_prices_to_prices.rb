class RenameProductPricesToPrices < ActiveRecord::Migration
  def change
    rename_table :product_prices, :prices
  end
end
