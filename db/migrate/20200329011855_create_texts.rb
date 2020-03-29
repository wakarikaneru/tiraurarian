class CreateTexts < ActiveRecord::Migration[5.2]
  def change
    create_table :texts do |t|
      t.integer :tweet_id
      t.integer :user_id
      t.text :content
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
