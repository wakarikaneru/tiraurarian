class CreateAccessLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :access_logs do |t|
      t.datetime :access_datetime
      t.string :ip_address
      t.string :url
      t.string :method
      t.string :referer
      t.integer :user_id

      t.timestamps
    end
  end
end
