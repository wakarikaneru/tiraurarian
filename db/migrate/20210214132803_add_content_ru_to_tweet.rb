class AddContentRuToTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :content_ru, :string
  end
end
