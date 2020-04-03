class AddLanguageToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :language, :string
  end
end
