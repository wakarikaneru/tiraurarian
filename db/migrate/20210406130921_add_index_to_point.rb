class AddIndexToPoint < ActiveRecord::Migration[6.1]
  def change
    add_index :points, :user_id
  end
end
