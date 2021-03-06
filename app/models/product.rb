class Product < ActiveRecord::Base
  has_one :product_price
  delegate :sd_price, :nsd_price, :msp_price, :list_price, :ip_price, to: :product_price
  validates_presence_of :name, :code, :uom, :part_number, :group_id, :category_id, :family_id

  GROUPS = [
    'Fencing',
    'Multi',
    'EC',
    'S&EC',
    'S&EC PC',
  ]

  CATEGORIES = [
    'Accessories',
    'Beach & Dune Protection',
    'Ditch & Swale Protection',
    'Drain Inlet Protection',
    'Drain Inlet Protection - PC',
    'Gully Bank & Shoreline',
    'Perimeter Protection',
    'Safety Barriers',
    'Samples',
    'Slope Protection',
    'Turbidity Barriers',
    'Wildlife Barriers',
  ]

  FAMILIES = [
    'ACC',
    'CG',
    'CIG',
    'DF',
    'DI Custom',
    'DiG',
    'DrG',
    'EF',
    'EG',
    'ESA',
    'GBS',
    'GG',
    'HSG',
    'Misc',
    'PG',
    'PW',
    'RPH',
    'SB',
    'SF',
    'TB',
  ]

  def group; GROUPS[group_id] end
  def category; CATEGORIES[category_id] end
  def family; FAMILIES[family_id] end
end