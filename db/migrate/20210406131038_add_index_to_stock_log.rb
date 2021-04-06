class AddIndexToStockLog < ActiveRecord::Migration[6.1]
  def change
    add_index :stock_logs, :datetime
  end
end
