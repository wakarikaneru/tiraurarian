namespace :stock_fluctuation do
  desc "stock_fluctuation"
  task stock_fluctuation: :environment do
    Stock.determine
    Stock.fluctuation
  end
  task determine: :environment do
    Stock.determine
  end
end
