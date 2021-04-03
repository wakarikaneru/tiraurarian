class AddIndexToMute < ActiveRecord::Migration[6.1]
  def change
    add_index :mutes, :user_id
    add_index :mutes, :target_id
  end
end
