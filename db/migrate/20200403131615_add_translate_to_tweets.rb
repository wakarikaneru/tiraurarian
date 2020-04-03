class AddTranslateToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :content_ja, :string
    add_column :tweets, :content_en, :string
    add_column :tweets, :content_zh, :string
  end
end
