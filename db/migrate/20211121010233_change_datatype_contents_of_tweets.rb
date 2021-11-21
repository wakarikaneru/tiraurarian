class ChangeDatatypeContentsOfTweets < ActiveRecord::Migration[6.1]
  def change
    change_column :tweets, :content_ja, :text, default: nil
    change_column :tweets, :content_en, :text, default: nil
    change_column :tweets, :content_zh, :text, default: nil
    change_column :tweets, :content_ru, :text, default: nil
    change_column :tweets, :content_ko, :text, default: nil
  end
end
