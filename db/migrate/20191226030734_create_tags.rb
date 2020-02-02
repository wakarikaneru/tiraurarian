class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.integer :tweet_id
      t.integer :user_id
      t.string :tag_string
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
