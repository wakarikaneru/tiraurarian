class AddIndexToNotice2 < ActiveRecord::Migration[6.1]
  def change
  add_index :notices, :create_datetime
  end
end
