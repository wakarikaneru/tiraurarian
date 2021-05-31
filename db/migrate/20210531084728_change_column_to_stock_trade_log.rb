class ChangeColumnToStockTradeLog < ActiveRecord::Migration[6.1]
  def change
    add_index :stock_trade_logs, :user_id
    add_index :stock_trade_logs, :create_datetime
  end
end
