class AddIndexToStock < ActiveRecord::Migration[6.1]
  def change
    add_index :stocks, :user_id
  end
end
