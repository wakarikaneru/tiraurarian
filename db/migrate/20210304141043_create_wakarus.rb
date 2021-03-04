class CreateWakarus < ActiveRecord::Migration[5.2]
  def change
    create_table :wakarus do |t|
      t.integer :user_id
      t.integer :tweet_id
      t.integer :create_datetime

      t.timestamps
    end
  end
end
