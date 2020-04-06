namespace :stock_fluctuation do
  desc "stock_fluctuation"
  task stock_fluctuation: :environment do
    Stock.fluctuation
  end
end
