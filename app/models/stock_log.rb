class StockLog < ApplicationRecord

  def self.generate(point = 0)
    stock_log = StockLog.new
    stock_log.datetime = Time.current
    stock_log.point = point
    stock_log.save!
  end
  
end
