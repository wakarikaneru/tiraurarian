class CreateDeleteLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :delete_logs do |t|
      t.integer :tweet_id
      t.string :tweet_content
      t.integer :tweet_user
      t.string :tweet_ip
      t.string :tweet_host
      t.integer :delete_user_id

      t.timestamps
    end
  end
end
