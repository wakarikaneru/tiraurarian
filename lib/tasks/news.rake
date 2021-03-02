namespace :news do
  desc "news"
  task stock_news: :environment do
    Stock.news
  end
end
