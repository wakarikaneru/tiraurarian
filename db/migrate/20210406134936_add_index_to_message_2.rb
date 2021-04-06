class AddIndexToMessage2 < ActiveRecord::Migration[6.1]
  def change
  add_index :messages, :create_datetime
  end
end
