class AddIndexToWakaru < ActiveRecord::Migration[6.1]
  def change
    add_index :wakarus, :tweet_id
    add_index :wakarus, :user_id
    add_index :wakarus, :create_datetime
  end
end
