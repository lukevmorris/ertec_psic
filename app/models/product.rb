class Product < ActiveRecord::Base
  has_one :product_price

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