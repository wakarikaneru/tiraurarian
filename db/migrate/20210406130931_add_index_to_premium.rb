class AddIndexToPremium < ActiveRecord::Migration[6.1]
  def change
    add_index :premia, :user_id
    add_index :premia, :limit_datetime
    add_index :premia, :create_datetime
  end
end
