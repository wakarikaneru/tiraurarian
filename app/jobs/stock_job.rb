class StockJob < ApplicationJob
  queue_as :stock

  def perform()
    Stock.determine
  end
end
