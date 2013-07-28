class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.timestamps
      t.timestamp :discontinued_on
      t.string :name
      t.string :uom
      t.string :code
      t.integer :part_number
      t.text :description
    end
  end
end