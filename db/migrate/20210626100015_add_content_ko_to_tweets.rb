class AddContentKoToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :content_ko, :string
  end
end
