class AddSentimentToTweet < ActiveRecord::Migration[6.1]
  def change
    add_column :tweets, :sentiment_score, :float, default: 0
    add_column :tweets, :sentiment_magnitude, :float, default: 0

    add_index :tweets, :sentiment_score
    add_index :tweets, :sentiment_magnitude
  end
end
