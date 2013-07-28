class ProductPrice < ActiveRecord::Base
  belongs_to :product

  def sd_price; to_currency(stocking_distributor) end
  def nsd_price; to_currency(non_stocking_distributor) end
  def msp_price; to_currency(managed_service_provider) end
  def ip_price; to_currency(installer_partner) end
  def list_price; to_currency(list) end

private
  def to_currency(price_integer)
    price_integer.to_f / 100
  end
end