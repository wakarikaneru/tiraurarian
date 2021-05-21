class CreateErrorLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :error_logs do |t|
      t.string :key
      t.string :exception_log
      t.text :exception_trace
      t.timestamps
    end
  end
end
