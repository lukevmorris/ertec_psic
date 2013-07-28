class Product < ActiveRecord::Base
  has_one :product_price
end