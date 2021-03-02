class News < ApplicationRecord

  def self.generate(priority, expiration, news_text)
    news = News.new
    news.priority = priority
    news.expiration = expiration
    news.news = news_text

    news.save!
  end

end
