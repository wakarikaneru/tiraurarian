class StockDetermineJob
  include Sidekiq::Worker

  def perform()
    Stock.determine
  end
end
