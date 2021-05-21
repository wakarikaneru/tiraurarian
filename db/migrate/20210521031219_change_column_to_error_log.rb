class ChangeColumnToErrorLog < ActiveRecord::Migration[6.1]
  def change
    add_index :error_logs, :key
  end
end
