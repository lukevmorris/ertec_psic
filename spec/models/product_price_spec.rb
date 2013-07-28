require 'spec_helper'

describe ProductPrice, '#sd_price' do
  it 'converts the stocking_distributor price to currency format' do
    product_price = build(:product_price, stocking_distributor: 1000)
    expect(product_price.sd_price).to eq 10
  end
end

describe ProductPrice, '#nsd_price' do
  it 'converts the non_stocking_distributor price to currency format' do
    product_price = build(:product_price, non_stocking_distributor: 1000)
    expect(product_price.nsd_price).to eq 10
  end
end

describe ProductPrice, '#msp_price' do
  it 'converts the managed_service_provider price to currency format' do
    product_price = build(:product_price, managed_service_provider: 1000)
    expect(product_price.msp_price).to eq 10
  end
end

describe ProductPrice, '#ip_price' do
  it 'converts the installer_partner price to currency format' do
    product_price = build(:product_price, installer_partner: 1000)
    expect(product_price.ip_price).to eq 10
  end
end

describe ProductPrice, '#list_price' do
  it 'converts the list price to currency format' do
    product_price = build(:product_price, list: 1000)
    expect(product_price.list_price).to eq 10
  end
end