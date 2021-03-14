class StockJob
  include Sidekiq::Worker

  def perform()
    Stock.fluctuation
  end
end
