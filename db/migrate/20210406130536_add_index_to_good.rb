class AddIndexToGood < ActiveRecord::Migration[6.1]
  def change
    add_index :goods, :tweet_id
    add_index :goods, :user_id
    add_index :goods, :create_datetime
  end
end
