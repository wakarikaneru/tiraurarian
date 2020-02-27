class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.integer :card_box_id
      t.integer :model_id
      t.integer :element
      t.integer :power
      t.datetime :create_datetime

      t.timestamps
    end
  end
end
