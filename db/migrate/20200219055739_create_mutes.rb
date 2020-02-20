class CreateMutes < ActiveRecord::Migration[5.0]
  def change
    create_table :mutes do |t|
      t.integer :user_id
      t.integer :target_id
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
