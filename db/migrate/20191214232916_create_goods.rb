class CreateGoods < ActiveRecord::Migration[5.0]
  def change
    create_table :goods do |t|
      t.integer :target_id
      t.integer :user_id
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
