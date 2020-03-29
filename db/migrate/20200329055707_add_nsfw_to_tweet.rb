class AddNsfwToTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :nsfw, :boolean
  end
end
