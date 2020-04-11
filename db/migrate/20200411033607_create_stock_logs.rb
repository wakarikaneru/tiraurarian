class CreateStockLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :stock_logs do |t|
      t.datetime :datetime
      t.integer :point, default: 0

      t.timestamps
    end
  end
end
