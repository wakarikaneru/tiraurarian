class CreatePremia < ActiveRecord::Migration[5.2]
  def change
    create_table :premia do |t|
      t.integer :user_id
      t.datetime :limit_datetime
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
