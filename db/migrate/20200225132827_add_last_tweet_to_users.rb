class AddLastTweetToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_tweet, :datetime
  end
end
