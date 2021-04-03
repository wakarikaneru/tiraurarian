class AddIndexToTweet < ActiveRecord::Migration[6.1]
  def change
    add_index :tweets, :user_id
    add_index :tweets, :parent_id
  end
end
