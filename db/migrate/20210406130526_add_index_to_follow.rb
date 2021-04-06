class AddIndexToFollow < ActiveRecord::Migration[6.1]
  def change
    add_index :follows, :user_id
    add_index :follows, :target_id
    add_index :follows, :create_datetime
  end
end
