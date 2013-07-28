require 'spec_helper'

describe Product, 'all price instance methods' do
  [ :sd_price, :nsd_price, :msp_price, :ip_price, :list_price ].each do |price_method|
    it 'delegates to its product_price' do
      price = double('price', price_method => nil)
      product = FactoryGirl.build(:product)
      product.stub(:product_price).and_return(price)
      product.send(price_method)
      expect(price).to have_received(price_method)
    end
  end
end