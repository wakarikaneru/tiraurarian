class CreateStockTradeLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_trade_logs do |t|
      t.integer :user_id
      t.integer :price
      t.integer :amount
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
