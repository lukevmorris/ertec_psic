require 'spec_helper'

describe ProductPrice, 'all instance price methods' do
  [
    [ :sd_price, :stocking_distributor],
    [ :nsd_price, :non_stocking_distributor],
    [ :msp_price, :managed_service_provider],
    [ :ip_price, :installer_partner],
    [ :list_price, :list],
  ].each do |method, field|
    it "converts the #{field} to currency format" do
      product_price = build(:product_price, field => 1000)
      expect(product_price.send(method)).to eq 10
    end
  end
end

describe ProductPrice, 'factory' do
  it 'is valid' do
    price = build(:product_price)
    expect(price).to be_valid
  end
end

describe ProductPrice, 'validations' do
  [ :stocking_distributor,
    :non_stocking_distributor,
    :managed_service_provider,
    :installer_partner,
    :list,
    :product_id,
  ].each do |field|
    it "is invalid without a present #{field} value" do
      price = build(:product_price, field => nil)
      expect(price).to_not be_valid
    end
  end
end