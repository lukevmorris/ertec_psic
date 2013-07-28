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