class CreateGamblingResults < ActiveRecord::Migration[5.2]
  def change
    create_table :gambling_results do |t|
      t.integer :user_id
      t.boolean :result
      t.integer :point
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
