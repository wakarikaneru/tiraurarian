class StockLog < ApplicationRecord

  def self.generate(datetime)
    stock_log = StockLog.new
    stock_log.datetime = datetime
    stock_log.point = nil

    stock_log.save!
    return stock_log
  end

  def set_point(point)
    if self.point == nil
      self.update(point: point)
    end
  end

end
