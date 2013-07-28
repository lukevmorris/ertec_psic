class AddGroupCategoryFamilyToProducts < ActiveRecord::Migration
  def change
    add_column :products, :group_id, :integer
    add_column :products, :category_id, :integer
    add_column :products, :family_id, :integer
  end
end
