class ProductPrice < ActiveRecord::Base
  belongs_to :product
  validates_presence_of :stocking_distributor, :non_stocking_distributor, :managed_service_provider,
                        :installer_partner, :list, :product_id

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