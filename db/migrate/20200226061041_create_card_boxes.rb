class CreateCardBoxes < ActiveRecord::Migration[5.0]
  def change
    create_table :card_boxes do |t|
      t.integer :user_id
      t.integer :size
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
