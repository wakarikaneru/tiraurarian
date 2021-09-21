class AddIndexToDeleteLog < ActiveRecord::Migration[6.1]
  def change
    add_index :delete_logs, :tweet_id
    add_index :delete_logs, :tweet_content
    add_index :delete_logs, :tweet_user
    add_index :delete_logs, :tweet_ip
    add_index :delete_logs, :tweet_host
    add_index :delete_logs, :delete_user_id
  end
end
