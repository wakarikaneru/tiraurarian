class RenameTweetUserToDeleteLog < ActiveRecord::Migration[6.1]
  def change
    rename_column :delete_logs, :tweet_user, :tweet_user_id
  end
end
