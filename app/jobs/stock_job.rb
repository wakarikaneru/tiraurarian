class StockJob < ApplicationJob
  queue_as :stock

  def perform()
    Stock.fluctuation
  end
end
