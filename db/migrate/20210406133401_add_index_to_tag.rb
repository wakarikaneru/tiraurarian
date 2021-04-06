class AddIndexToTag < ActiveRecord::Migration[6.1]
  def change
    add_index :tags, :tweet_id
    add_index :tags, :user_id
    add_index :tags, :tag_string
  end
end
