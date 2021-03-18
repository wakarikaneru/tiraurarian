namespace :stock do
  desc "stock"
  task fluctuation: :environment do
    StockJob.perform_later
  end
end
