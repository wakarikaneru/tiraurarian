class AddIndexToMessage < ActiveRecord::Migration[6.1]
  def change
    add_index :messages, :user_id
    add_index :messages, :read_flag
    add_index :messages, :sender_id
  end
end
