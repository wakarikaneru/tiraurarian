class AddLanguageConfidenceToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :language_confidence, :float, default: 0
  end
end
