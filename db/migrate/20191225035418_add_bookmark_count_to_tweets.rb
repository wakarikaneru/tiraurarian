class AddBookmarkCountToTweets < ActiveRecord::Migration[5.0]
  def change
    add_column :tweets, :bookmark_count, :integer, default: 0
  end
end
