class AddIndexToText < ActiveRecord::Migration[6.1]
  def change
    add_index :texts, :tweet_id
    add_index :texts, :user_id
    add_index :texts, :create_datetime
  end
end
