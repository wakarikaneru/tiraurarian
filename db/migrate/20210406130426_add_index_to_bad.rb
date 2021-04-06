class AddIndexToBad < ActiveRecord::Migration[6.1]
  def change
    add_index :bads, :tweet_id
    add_index :bads, :user_id
    add_index :bads, :create_datetime
  end
end
