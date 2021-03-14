class CreateStockCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :stock_companies do |t|
      t.string :name
      t.float :price_target
      t.float :price
      t.float :coefficient

      t.timestamps
    end
  end
end
