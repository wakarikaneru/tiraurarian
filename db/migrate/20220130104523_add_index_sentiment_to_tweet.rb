class AddIndexSentimentToTweet < ActiveRecord::Migration[6.1]
  def change
    add_index :tweets, :sentiment_score
    add_index :tweets, :sentiment_magnitude
  end
end
