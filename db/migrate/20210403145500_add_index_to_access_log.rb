class AddIndexToAccessLog < ActiveRecord::Migration[6.1]
  def change
    add_index :access_logs, :access_datetime
    add_index :access_logs, :ip_address
  end
end
