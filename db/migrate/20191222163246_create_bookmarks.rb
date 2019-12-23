class CreateBookmarks < ActiveRecord::Migration[5.0]
  def change
    create_table :bookmarks do |t|
      t.integer :tweet_id
      t.integer :user_id
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
