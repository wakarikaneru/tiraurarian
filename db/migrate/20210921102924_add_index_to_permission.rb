class AddIndexToPermission < ActiveRecord::Migration[6.1]
  def change
    add_index :permissions, :user_id
    add_index :permissions, :level
  end
end
