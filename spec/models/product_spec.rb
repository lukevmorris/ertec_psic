require 'spec_helper'

describe Product, 'all price instance methods' do
  [ :sd_price, :nsd_price, :msp_price, :ip_price, :list_price ].each do |price_method|
    it 'delegates to its product_price' do
      price = double('price', price_method => nil)
      product = build(:product)
      product.stub(:product_price).and_return(price)
      product.send(price_method)
      expect(price).to have_received(price_method)
    end
  end
end

describe Product, 'factory' do
  it 'is valid' do
    product = build(:product)
    expect(product.save).to be_true
  end
end

describe Product, 'validations' do
  [ :name, :code, :uom, :part_number, :group_id, :category_id, :family_id ].each do |field|
    it "is invalid without a present #{field} value" do
      product = build(:product, field => nil)
      expect(product.save).to be_false
    end
  end
end