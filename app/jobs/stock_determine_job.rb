class StockDetermineJob < ApplicationJob
  queue_as :stock_determine

  def perform()
    Stock.determine
  end
end
