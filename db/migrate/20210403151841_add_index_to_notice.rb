class AddIndexToNotice < ActiveRecord::Migration[6.1]
  def change
    add_index :notices, :user_id
    add_index :notices, :read_flag
    add_index :notices, :sender_id
  end
end
