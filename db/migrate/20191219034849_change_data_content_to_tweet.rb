class ChangeDataContentToTweet < ActiveRecord::Migration[5.0]
  def change
    change_column :tweets, :content, :text
  end
end
