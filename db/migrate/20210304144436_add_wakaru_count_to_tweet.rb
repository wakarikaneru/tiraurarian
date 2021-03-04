class AddWakaruCountToTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :wakaru_count, :integer, default: 0
  end
end
