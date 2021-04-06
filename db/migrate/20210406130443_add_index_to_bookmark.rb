class AddIndexToBookmark < ActiveRecord::Migration[6.1]
  def change
    add_index :bookmarks, :tweet_id
    add_index :bookmarks, :user_id
    add_index :bookmarks, :create_datetime
  end
end
